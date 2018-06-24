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

if (!local (leader _group)) then {
    private _pfh = _group getVariable [QGVAR(pfh), -1];
    [_pfh] call CBA_fnc_removePerFrameHandler;

    [QGVAR(targetPFH), _group, leader _group] call CBA_fnc_targetEvent;
};

private _settings = _group getVariable [QGVAR(settings), []];

private _assignedTask = [_settings, "task"] call CBA_fnc_hashGet;
private _taskChanged = false;
private _changed = false;

if (_taskChanged) then {
    [_settings, "tasksState", "init"] call CBA_fnc_hashSet;
};

//systemChat format [QEFUNC(task,%1), _assignedTask];
private _taskFunction = missionNamespace getVariable (format [QEFUNC(tasks,%1), _assignedTask]);
//systemChat format ["task: %1", _taskFunction];
//_changed = [_group] call _taskFunction;
//systemChat format ["changed %1", _changed];
if (((units _group) select {alive _x}) isEqualTo []) then {
    private _pfh = _group getVariable [QGVAR(pfh), -1];
    [_pfh] call CBA_fnc_removePerFrameHandler;

    deleteGroup _group;
};

if (_changed) then {
    _group setVariable [QGVAR(settings), _settings, true];
};
