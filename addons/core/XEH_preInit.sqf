#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.sqf"

if (isServer) then {
    DGVAR(groupRegisters) = 0;
    DGVAR(groupTemplates) = [] call CBA_fnc_hashCreate;
};

ADDON = true;
