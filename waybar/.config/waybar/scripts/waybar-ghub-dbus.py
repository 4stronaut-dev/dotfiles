#!/usr/bin/env python3
import json
import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

def on_properties_changed(interface, changed_properties, invalidated_properties):
    if 'Percentage' in changed_properties:
        percentage = changed_properties['Percentage']
        print(json.dumps({"text": f"Mouse {percentage:.0f}%", "class": "discharging" if percentage < 100 else "charging"}))
        print("", flush=True) # Force output

def main():
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()

    # Connect to the specific UPower device
    device_path = "/org/freedesktop/UPower/devices/hidpp_battery_2" # Use your device path from `upower --dump`
    device = bus.get_object("org.freedesktop.UPower", device_path)

    # Get initial state
    props = device.GetAll("org.freedesktop.DBus.Properties", dbus_interface="org.freedesktop.DBus.Properties")
    percentage = props['Percentage']
    print(json.dumps({"text": f"Mouse {percentage:.0f}%", "class": "discharging" if percentage < 100 else "charging"}), flush=True)

    # Listen for changes
    bus.add_signal_receiver(on_properties_changed,
                            signal_name="PropertiesChanged",
                            dbus_interface="org.freedesktop.DBus.Properties",
                            path=device_path,
                            interface_keyword="interface")

    loop = GLib.MainLoop()
    loop.run()

if __name__ == "__main__":
    main()
