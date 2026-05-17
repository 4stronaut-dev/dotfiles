#!/usr/bin/env python3

import hid

# Logitech Vendor ID
LOGITECH_VID = 0x046D

def list_logitech_devices():
    """List all connected Logitech HID devices."""
    devices = hid.enumerate()
    logitech_devices = [d for d in devices if d['vendor_id'] == LOGITECH_VID]
    for device_info in logitech_devices:
        print(f"Device Found:")
        print(f"  Path: {device_info['path']}")
        print(f"  Manufacturer: {device_info['manufacturer_string']}")
        print(f"  Product: {device_info['product_string']}")
        print(f"  Serial: {device_info['serial_number']}")
        print(f"  VID: {hex(device_info['vendor_id'])}, PID: {hex(device_info['product_id'])}")
        print("---")
    return logitech_devices

def get_device_info(path):
    """Open a device and get basic info."""
    try:
        device = hid.Device(path=path)
        print(f"Opened Device: {device.manufacturer} {device.product}")
        print(f"  Serial Number: {device.serial}")
        # Send a simple GET request to Feature 0x0000 (Root Index) to check protocol
        # This is a basic HID++ 2.0 command. The exact format depends on the feature.
        # response = device.send_feature_report([0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        device.close()
    except IOError as ex:
        print(f"Error opening device: {ex}")

# List all Logitech devices
logitech_devices = list_logitech_devices()

# Open and query the first Logitech device found
if logitech_devices:
    get_device_info(logitech_devices[0]['path'])   
