/*
 * Author: TheMagnetar
 * Changes the assigned task and updates the state machine.
 *
 * Arguments:
 * 0: Group <OBJECT>
 * 1: Task <STRING>
 * 2: Optional parameters <ARRAY>
 *
 * Return Value:
 * Change successful
 *
 * Example:
 * [group player, "defend"] call mai_tasks_fnc_changeAssignedTask
 *
 * Public: Yes
 */
#include "script_component.hpp"
EXEC_CHECK(SERVERHC);

params [
    ["_group", grpNull, [grpNull]],
    ["_task", "", [""]],
    ["_options", [], [[]]]
];

if (isNull _group || {_task isEqualTo "" || {!((toLower _task) in GVAR(definedTasks))}}) exitWith {false};

private _settings = _group getVariable [QEGVAR(core,settings), []];
_options pushBack ["task", _task];
_settings = [_group, _settings] call EFUNC(core,parseOptions);

_group setVariable [QEGVAR(core,settings), _settings, true];

true
