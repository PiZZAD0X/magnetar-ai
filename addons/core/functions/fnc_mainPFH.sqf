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

if (!local (leader _group)) {
    [GVAR(mainLoopPFH)] call CBA_fnc_removePerFrameHandler;
    GVAR(mainLoopPFH) = -1;
    [QGVAR(targetPFH), [_group], leader _group] call CBA_fnc_targetEvent
}

private _settings = _group getVariable [QGVAR(settings), []];

private _assignedTask = [_settings, "task"] call CBA_fnc_hashGet;
private _taskChanged = false;
private _changed = false;

if (_taskChanged) then {
    [_settings, "taskState", "init"] call CBA_fnc_hashSet;
};

private _taskFunction = missionNamespace getVariable (format [QEFUNC(task,%1), _assignedTask]);
_changed = [_group] call _taskFunction;

if (((units _group) select {alive _x}) isEqualTo []) then {
    [GVAR(mainLoopPFH)] call CBA_fnc_removePerFrameHandler;
    GVAR(mainLoopPFH) = -1;
    deleteGroup _group;
};

if (_changed) then {
    _group setVariable [QGVAR(settings), _settings, true];
};
