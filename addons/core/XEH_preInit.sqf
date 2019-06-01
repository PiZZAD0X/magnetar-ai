#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.sqf"

if (isServer) then {
    DGVAR(groupRegisters) = [];
    DGVAR(groupTemplates) = [] call CBA_fnc_hashCreate;
};

[QGVAR(registerGroup), {
    params ["_group", ["_registerMarker", ""]];

    GVAR(groupRegisters) pushBack [_group, _registerMarker];

    if (_registerMarker isEqualTo "") exitWith {};

    private _markerGroups = missionNamespace getVariable [format [QGVAR(%1), _registerMarker], []];
    _markerGroups pushBack _group;
    missionNamespace setVariable [format [QGVAR(%1), _registerMarker], _markerGroups];
}] call CBA_fnc_addEventHandler;

[QGVAR(unregisterGroup), {
    params ["_group"];

    {
        if ((_x select 0) isEqualTo _group) exitWith {
            private _markerGroups = missionNamespace getVariable [format [QGVAR(%1), _x select 1], []];
            _markerGroups deleteAt (_markerGroups find _group);

            GVAR(groupRegisters) deleteAt _forEachIndex;
        };
    } forEach GVAR(groupRegisters);
}] call CBA_fnc_addEventHandler;

ADDON = true;
