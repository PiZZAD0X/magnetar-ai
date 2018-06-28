#include "script_component.hpp"

[QGVAR(registerGroup), {
    params ["_group", "_marker"];

    private _settings = _group getVariable [QGVAR(settings), []];
    [_settings, "groupId", GVAR(groupRegisters)] call CBA_fnc_hashSet;
    _group setVariable [QGVAR(settings), _settings];

    private _markerGroups = missionNamespace getVariable [format [QGVAR(%1), _marker], []];
    _markerGroups pushBack _group;
    missionNamespace setVariable [format [QGVAR(%1), _marker], _markerGroups];

    GVAR(groupRegisters) = GVAR(groupRegisters) + 1;
}] call CBA_fnc_addEventHandler;
