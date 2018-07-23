#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.sqf"

if (isServer) then {
    DGVAR(groupRegisters) = 0;
    GVAR(groupTemplates);
};

ADDON = true;
