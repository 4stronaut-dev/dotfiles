#include <sdbus-c++/sdbus-c++.h>
#include <iostream>
#include <json/json.h> // Requires jsoncpp library

class WaybarUPowerModule {
private:
    std::unique_ptr<sdbus::IProxy> device_proxy_;

    void onPropertiesChanged(const std::string& interface,
                             const std::map<std::string, sdbus::Variant>& changed_properties,
                             const std::vector<std::string>& invalidated_properties) {
        auto it = changed_properties.find("Percentage");
        if (it != changed_properties.end()) {
            double percentage = it->second.get<double>();
            Json::Value output;
            output["text"] = "Mouse " + std::to_string(static_cast<int>(percentage)) + "%";
            output["class"] = (percentage < 100.0) ? "discharging" : "charging";
            std::cout << output.toStyledString() << std::endl;
            std::cout << std::flush;
        }
    }

public:
    WaybarUPowerModule(const std::string& object_path) {
        auto connection = sdbus::createSystemBusConnection();
        // Corrected line: Use sdbus::createProxy()
        auto device_proxy_ = sdbus::createProxy("org.freedesktop.UPower", object_path);

        device_proxy_->registerSignalHandler("org.freedesktop.DBus.Properties", "PropertiesChanged",
                                             &WaybarUPowerModule::onPropertiesChanged, this);
        device_proxy_->finishRegistration();

        // Get initial state
        sdbus::Variant variant;
        device_proxy_->getProperty("Percentage") >> variant;
        double initial_percentage = variant.get<double>();
        Json::Value output;
        output["text"] = "Mouse " + std::to_string(static_cast<int>(initial_percentage)) + "%";
        output["class"] = (initial_percentage < 100.0) ? "discharging" : "charging";
        std::cout << output.toStyledString() << std::endl;
        std::cout << std::flush;

        connection->enterEventLoop();
    }
};

int main() {
    try {
        WaybarUPowerModule module("/org/freedesktop/UPower/devices/hidpp_battery_2");
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
    return 0;
}   
