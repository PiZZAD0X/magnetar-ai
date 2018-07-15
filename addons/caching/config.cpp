#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"mai_main"};
        authors[] = {"TheMagnetar"};
        author = "MAI-Team";
        authorUrl = "http://www.github.com/theMagnetar";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "StateMachine.hpp"
