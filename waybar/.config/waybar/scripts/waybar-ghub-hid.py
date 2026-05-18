#!/usr/bin/env python3

import hid

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
    'presentation': '󰻅',    # 0x04: presentation (e.g., PRESENTER)
    'trackball': '🖲',    # 0x05: trackball
    'trackpad': '󰟸',    # 0x06: trackpad
    'phone': '',    # 0x07: phone
    'video camera': '',    # 0x08: video camera
    'remote control': '󰑔',    # 0x09: remote control
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


def find_hidpp_devices():
    """Find all HID++ 2.0 capable devices."""
    devices = hid.enumerate()
    hidpp_devices = []
    for d in devices:
        # Logitech VID is 0x046d
        if d['vendor_id'] == 0x046d:
            # Check for Logitech defined HID++ 2.0 usage page range (0xFF00 - 0xFFFF)
            if 0xFF00 <= d['usage_page'] <= 0xFFFF:
                hidpp_devices.append(d)
    return hidpp_devices

def send_feature_command(device, feature_index, function, params=[]):
    """Send a HID++ 2.0 feature command and return response."""
    # Short report ID, device index, feature index, function, software ID
    report = [0x10, 0x01, feature_index, function, 0x00]
    # Add parameters (max 2 bytes for short report)
    report.extend(params[:2])
    # Pad to 7 bytes
    report.extend([0] * (7 - len(report)))
    device.write(bytes(report))
    # Read response (7 bytes)
    response = device.read(7)
    return response

def main():
    devices = find_hidpp_devices()
    if not devices:
        print("No HID++ 2.0 devices found.")
        return

    for dev_info in devices:
        print(f"Found device: {dev_info['product_string']} (VID: {hex(dev_info['vendor_id'])}, PID: {hex(dev_info['product_id'])})")
        
        try:
            device = hid.Device(path=dev_info['path'])
            # Step 1: Use IRoot (feature index 0x00) to get feature count and table
            response = send_feature_command(device, 0x00, 0x00, [0x00, 0x00])
            if response:
                feature_count = response[4]
                print(f"  Supported Features ({feature_count}):")
                
                # Step 2: Get feature IDs from feature table
                response = send_feature_command(device, 0x00, 0x10, [0x00])
                if response and len(response) >= 7:
                    # Parse feature table (3-byte chunks after header)
                    table_data = response[5:] + device.read(15)  # Read more if needed
                    feature_ids = []
                    for i in range(0, min(feature_count*3, len(table_data)), 3):
                        feature_id = int.from_bytes(table_data[i:i+3], 'big')
                        feature_ids.append(feature_id)
                    
                    # Step 3: Query IFeatureInfo (index 0x01) for each feature
                    for feat_id in feature_ids:
                        info_response = send_feature_command(device, 0x01, 0x00, [(feat_id >> 8) & 0xFF, feat_id & 0xFF])
                        if info_response:
                            functions = info_response[4]
                            events = info_response[5]
                            print(f"    Feature ID: {hex(feat_id)}, Functions: {functions}, Events: {events}")
            device.close()
        except Exception as e:
            print(f"  Error: {e}")

if __name__ == "__main__":
    main()   
