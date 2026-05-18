#!/usr/bin/env python3

import subprocess
import json
import sys
import argparse
import os
from enum import StrEnum
from pathlib import Path

# Standard HID++ 2.0 Feature IDs (FIDs) used by the linux kernel hid-logitech-hidpp.c (used commit: d4eb7b2)
class FID(StrEnum):
    # Important FIDs
    ROOT = '{0000}' # 0x0000 IRoot
    # 0x0001 IFeatureSet
    # 0x0002 IFeatureInfo
    
    # Common FIDs
    #FID_DEVICE_INFO = '0003' # 0x0003 Device Information
    # 0x0004 Unit ID
    DEVICE_NAME = '{0005}' # 0x0005 Device Name and Type
    # 0x0006 Device Groups
    # 0x0007 Device Friendly Name
    # 0x0008 Keep-Alive
    # 0x0020 Config Change
    # 0x0021 32-byte Unique Random Identifier
    # 0x0030 Target Software
    # 0x0080 Wireless Signal Strength
    # 0x00c0 DFU Control Legacy
    # 0x00c1 DFU Control Unsigned
    # 0x00c2 DFU Control Signed
    # 0x00d0 DFU
    # 0x1000 Battery Level Status
    # 0x1001 Battery Voltage
    UNIFIED_BATTERY = '{1004}' # 0x1004 Unified Battery
    # 0x1010 Charging Control
    # 0x1814 Change Host
    # 0x1981 Backlight 1
    # 0x1982 Backlight 2
    # 0x1a00 PresenterControl
    # 0x1b00 Keyboard reprogrammable keys and Mouse buttons 1
    # 0x1b01 Keyboard reprogrammable Keys and Mouse buttons 2
    # 0x1b02 Keyboard reprogrammable Keys and Mouse buttons 3
    # 0x1b03 Keyboard reprogrammable Keys and Mouse buttons 4
    # 0x1b04 Keyboard reprogrammable Keys and Mouse buttons 5
    # 0x1bc0 Report HID Usages
    # 0x1c00 Persistent Remappable Action
    # 0x1d4b Wireless Device Status
    # 0x1df0 Remaining Pairings
    
    # Mouse specific FIDs
    # 0x2001 Swap left/right button
    # 0x2005 Button Swap Cancel
    # 0x2006 Pointer Axes Orientation
    # 0x2100 Vertical Scrolling
    # 0x2110 SmartShift wheel
    # 0x2120 High-Resolution Scrolling
    # 0x2121 HiRes Wheel
    # 0x2130 Ratchet Wheel
    # 0x2150 Thumbwheel
    # 0x2200 Mouse Pointer
    ADJUSTABLE_DPI = '{2201}' # 0x2201 Adjustable DPI
    # 0x2205 Pointer Motion Scaling
    # 0x2230 Sensor angle snapping
    # 0x2240 Surface Tuning
    # 0x2400 Hybrid Tracking Engine
    
    # Keyboard specific FIDs
    # 0x40a0 Fn Inversion
    FN_INVERSION_WITH_DEFAULT = '{40A2}' # 0x40a2 Fn Inversion, with default state
    # 0x40a3 Fn Inversion, for multi-host devices
    # 0x4100 Encryption
    # 0x4220 Lock Key State
    # 0x4301 Solar Keyboard Dashboard Feature
    # 0x4520 Keyboard Layout
    # 0x4521 Disable Keys
    # 0x4522 Disable Keys By Usage
    # 0x4530 Dual Platform
    # 0x4540 Keyboard International Layouts
    # 0x4600 Crown
    
    # Touchpad specific FIDs
    # 0x6010 Touchpad FW items
    # 0x6011 Touchpad SW Items
    # 0x6012 Touchpad Win8 FW items
    # 0x6020 TAP enable
    # 0x6021 TAP enable Extended
    # 0x6030 Cursor Ballistic
    # 0x6040 Touchpad resolution divider
    # 0x6100 TouchPad Raw XY
    # 0x6110 TouchMouse Raw TouchPoints
    # 0x6120 BT TouchMouse Settings
    # 0x6500 Gestures1
    # 0x6501 Gestures2
    
    # Gaming Devices specific FIDs <- most relevant in our case
    #FID_GAMING_GKEYS = '8010' # 0x8010 Gaming G-Keys
    #FID_GAMING_MKEYS = '8020' # 0x8020 Gaming M-keys
    # 0x8030 MacroRecord, MR Key
    # 0x8040 Brightness control
    ADJUSTABLE_REPORT_RATE = '{8060}' # 0x8060 Adjustable Report Rate
    COLOR_LED_EFFECTS = '{8070}' # 0x8070 Color LED Effects
    #FID_RGB_EFFECTS = b'8071' # 0x8071 RGB Effects
    PER_KEY_LIGHTNING = '{8080}' # 0x8080 Per Key Lighting
    # 0x8090 Mode status
    ONBOARD_PROFILES = '{8100}'# 0x8100 Onboard Profiles
    # 0x8110 Mouse Button Filter

# Mapping custom icons to possible device types based on Logitech HID++2.0 protocol
type_icon_map = {
    'keyboard': '',    # 0x01: keyboard
    'mouse': '',   # 0x02: mouse
    'numpad': '⌨',   # 0x03: numpad
    'presentation': '󰑔',    # 0x04: presentation (e.g., PRESENTER)
    'trackball': '🖲',    # 0x05: trackball
    'trackpad': '󰟸',    # 0x06: trackpad
    'phone': '',    # 0x07: phone
    'video camera': '',    # 0x08: video camera
    'remote control': '󰻅',    # 0x09: remote control
    'navigational': '󰆾',    # 0x0A: navigational (e.g., scroll wheel)
    'system control': '󰾰',    # 0x0B: system control
    'web pad': '󰟸',    # 0x0C: web pad
    'transport control': '󰴽',    # 0x0D: transport control
    'standard and gaming mouse': '󰍿',    # 0x0E: standard and gaming mouse
    'standard keyboard': '🖮',    # 0x0F: standard keyboard
    'joystick': '🕹',    # 0x10: joystick
    'gamepad': '󰊗',    # 0x11: gamepad
    'pen': '',    # 0x12: pen
    'multi-axis controller': '󰐫',    # 0x13: multi-axis controller
    'unknown': '∅'    # 0xFF: unknown
}

# Mapping the FID to how many lines need to be extracted after FID occurence from 'solaar show' output
# HINT: run solaar show in a terminal first to check the number of needed extracted lines per FID
fid_to_extractedlinesnum_map = {
    FID.ROOT.value : 0,
    FID.DEVICE_NAME.value : 2,
    FID.UNIFIED_BATTERY.value : 1,
    FID.ADJUSTABLE_DPI.value : 2,
    FID.FN_INVERSION_WITH_DEFAULT.value : 4,
    FID.ADJUSTABLE_REPORT_RATE.value : 2,
    FID.COLOR_LED_EFFECTS.value: 0,
    FID.PER_KEY_LIGHTNING.value: 0,
    FID.ONBOARD_PROFILES.value : 3
}

# Start
try:
    # Check the input arguments for --next or --prev and handle device index storage
    parser = argparse.ArgumentParser()
    parser.add_argument('--prev', action='store_true')
    parser.add_argument('--next', action='store_true')
    args = parser.parse_args()
    index_file = Path(__file__).parent / 'ghub-device-index'
    if os.path.exists(index_file):
        with open(index_file, 'r') as f:
            device_index = int(f.read().strip())
    else:
        device_index = 0

    # Run 'solaar show' and capture output
    call = subprocess.run(
        ['solaar', 'show'],
        text=True,
        stderr=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
    )
    out = call.stdout.strip().splitlines()

    # Extract feature data from solaar output for all detected devices
    # initialize device list. Srtucture of the list will be like this:
    # [{'Name': '','Kind': '', 'Features': []},..]
    devices = []
    # iteratae through the enumareated list of solaar output, i is needed to directly address lines
    for i, line in enumerate(out):
        # iterate through the FID-extracted lines mapping 
        for fid, n in fid_to_extractedlinesnum_map.items():
            # check matching FID in the given line
            if fid in line and i + n < len(out):
                if fid == FID.ROOT.value:
                    # If FID_ROOT is founded, the list is appended by a new device dictionary
                    devices.append({})
                elif fid == FID.DEVICE_NAME.value:
                    next_lines = out[i+1:i+1+n]
                    key_value_pairs = (l.strip().split(':', 1) for l in next_lines)
                    device_data = {k.strip(): v.strip() for k, v in key_value_pairs}
                    device_data.update({'Features':[]})
                    devices[-1].update(device_data)
                else:
                    next_lines = out[i:i+1+n]
                    next_lines[0] = f'{fid}: {FID(fid).name}'
                    key_value_pairs = (l.strip().split(':',1) for l in next_lines)
                    device_data = {k.strip(): v.strip() for k, v in key_value_pairs}
                    devices[-1]['Features'].extend([device_data])
                break

    if args.prev:
        device_index = (device_index - 1) % len(devices)
    elif args.next:
        device_index = (device_index + 1) % len(devices)

    with open(index_file, 'w') as f:
        f.write(str(device_index))
    
    # Convert the extracted info to the specific JSON required by waybar
    # Initialize data for waybar 
    waybar_input = {
        'text': '',
        'alt': '',
        'tooltip': '',
        'class': 'no-battery',
        'percentage': 0
    }
    # Generating tooltip description
    tooltip = '(left click) - switch to short format\t(right click) - open solaar\n'
    tooltip += '(scroll up/down) - show previous/next device(takes few secs)\n'
    tooltip += '------------------------------------------------------------------------------\n'
    tooltip += f'Number of connected Logitech HID++2.0 devices: {len(devices)}.\n'
    tooltip += 'List of connected devices and their features:\n'
    for device in devices:
        tooltip += f'\n{type_icon_map[device['Kind']]}: {device['Name']}\n'
        tooltip += 'Features:\n'
        for feature in device['Features']:
            for i in range(len(feature)):
                if (0 == i):
                    tooltip += f'\t{list(feature.values())[0]}\n'
                else:
                    tooltip += f'\t\t{list(feature.keys())[i]}: {list(feature.values())[i]}\n'

    waybar_input['tooltip'] = tooltip
    waybar_input['text'] = f'{devices[device_index]['Name']}'
    waybar_input['alt'] = f'{type_icon_map[devices[device_index]['Kind']]}'
    device_with_battery = next((d for d in devices[device_index]['Features'] if FID.UNIFIED_BATTERY.value in d), None)
    if device_with_battery:
        waybar_input['percentage'] = int(device_with_battery['Battery'].split(',')[0].rstrip('%'))
        waybar_input['class'] = device_with_battery['Battery'].split(',')[1].split('.')[1].lower()

    # Immediate print data for waybar
    print(json.dumps(waybar_input))
    sys.stdout.flush()

except Exception as e:
    print(json.dumps({'text': 'G-Hub error', 'tooltip': str(e), 'class': 'notavailable'}))

