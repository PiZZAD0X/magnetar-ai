/*
 * Author: TheMagnetar
 * Initialises a group.
 *
 * Arguments:
 * 0: Unit <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call mai_core_fnc_init
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group"];

private _settings = _group getVariable [QGVAR(settings), []];

private _assignedTask = [_settings, "task"] call CBA_fnc_hashGet;
private _taskChanged = false;

if (_taskChanged) then {
    [_settings, "taskState", "init"] call CBA_fnc_hashSet;
};

private _taskFunction = missionNamespace getVariable (format [QEFUNC(task,%1), _assignedTask]);
[_group] call _taskFunction;
