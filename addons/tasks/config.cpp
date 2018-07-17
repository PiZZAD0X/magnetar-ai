#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"mai_main", "mai_vehicle", "mai_building"};
        authors[] = {"TheMagnetar"};
        author = "MAI-Team";
        authorUrl = "https://gitlab.gruppe-w.de/Magnetar";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "StateMachine.hpp"
