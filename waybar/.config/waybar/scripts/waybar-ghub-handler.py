#!/usr/bin/env python3

import subprocess
import json
import sys

# Standard HID++ 2.0 Feature IDs (FIDs) used by the linux kernel hid-logitech-hidpp.c (used commit: d4eb7b2)
# Important FIDs
FID_ROOT = "0000" # 0x0000 IRoot
# 0x0001 IFeatureSet
# 0x0002 IFeatureInfo

# Common FIDs
#FID_DEVICE_INFO = "0003" # 0x0003 Device Information
# 0x0004 Unit ID
FID_DEVICE_NAME = "0005" # 0x0005 Device Name and Type
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
FID_UNIFIED_BATTERY = "1004" # 0x1004 Unified Battery
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
FID_ADJUSTABLE_DPI = "2201" # 0x2201 Adjustable DPI
# 0x2205 Pointer Motion Scaling
# 0x2230 Sensor angle snapping
# 0x2240 Surface Tuning
# 0x2400 Hybrid Tracking Engine

# Keyboard specific FIDs
# 0x40a0 Fn Inversion
# 0x40a2 Fn Inversion, with default state
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
#FID_GAMING_GKEYS = "8010" # 0x8010 Gaming G-Keys
#FID_GAMING_MKEYS = "8020" # 0x8020 Gaming M-keys
# 0x8030 MacroRecord, MR Key
# 0x8040 Brightness control
FID_ADJUSTABLE_REPORT_RATE = "8060" # 0x8060 Adjustable Report Rate
#FID_COLOR_LED_EFFECTS = "8070" # 0x8070 Color LED Effects
#FID_RGB_EFFECTS = b"8071" # 0x8071 RGB Effects
# 0x8080 Per Key Lighting
# 0x8090 Mode status
FID_ONBOARD_PROFILES = "8100" # 0x8100 Onboard Profiles
# 0x8110 Mouse Button Filter

# Mapping the FID to how many lines need to be extracted from 'solaar show' output
fid_to_num_of_extractedlines_map = {
    f"{{{FID_ROOT}}}" : 0,
    f"{{{FID_DEVICE_NAME}}}" : 2,
    f"{{{FID_UNIFIED_BATTERY}}}" : 1,
    f"{{{FID_ADJUSTABLE_DPI}}}" : 2,
    f"{{{FID_ADJUSTABLE_REPORT_RATE}}}" : 3,
    f"{{{FID_ONBOARD_PROFILES}}}" : 3
}

try:
    # Run 'solaar show' and capture output
    call = subprocess.run(["solaar", "show"], stderr=subprocess.DEVNULL, stdout=subprocess.PIPE, text=True)
    out = call.stdout.strip().splitlines()

    devices = []
    device_count = 0

    for i, line in enumerate(out):
        for fid, n in fid_to_num_of_extractedlines_map.items():
            if fid in line and i + n < len(out):
                if fid == f"{{{FID_ROOT}}}":
                    device_count += 1
                    devices.append([{"device":device_count}])
                else:
                    next_lines = out[i+1:i+1+n]
                    key_value_pairs = (line.strip().split(':', 1) for line in next_lines)
                    device_data = {k.strip(): v.strip() for k, v in key_value_pairs}
                    devices[-1].extend([device_data])
                break

    # def get_value_from_device(devices, key):
    #     for device in devices:
    #         for descriptor in device:
    #             if key in descriptor:
    #                 return descriptor[key]
    #     return None

    # Convert the extracted info to the specific JSON required by waybar
    name = devices[0][1]["Name"]
    kind = devices[0][1]["Kind"]
    battery_level = devices[0][2]["Battery"].split(',')[0].rstrip("%")
    battery_status = devices[0][2]["Battery"].split(',')[1].split('.')[1].lower()
    profile = devices[0][3]["Onboard Profiles (saved)"]
    rate = devices[0][4]["Report Rate"]
    sens = devices[0][5]["Sensitivity (DPI) (saved)"]


    waybar_data = {
        "text": f"{profile}:{sens}dpi,{rate}",
        "tooltip": f"{kind}: {name} @ {battery_level}% battery level",
        "class": f"{battery_status}",
        "percentage": int(battery_level)
    }
    
    print(json.dumps(waybar_data))
    sys.stdout.flush()

except Exception as e:
    print(json.dumps({"text": "o-o", "tooltip": str(e), "class": "solaar-error"}))

