#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.sqf"

[QGVAR(registerGroup), {
    params ["_group", "_marker"];
    {
        private _settings = _group getVariable [QGVAR(settings), []];
        [_settings, "groupId", GVAR(groupRegisters)] call CBA_fnc_hashSet;
        _group setVariable [QGVAR(settings), _settings];
        private _markerGroups = missionNamespace getVariable [format [QGVAR(%1), _x # 0], []];
        _markerGroups pushBack _group;
        missionNamespace setVariable [format [QGVAR(%1), _x # 0], _markerGroups];

        GVAR(groupRegisters) = GVAR(groupRegisters) + 1;
    } forEach _marker;
}] call CBA_fnc_addEventHandler;

if (isServer) then {
    DGVAR(groupRegisters) = 0;
    DGVAR(groupTemplates) = [] call CBA_fnc_hashCreate;
};

ADDON = true;
