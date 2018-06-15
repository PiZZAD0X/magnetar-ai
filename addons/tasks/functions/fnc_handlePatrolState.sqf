/*
 * Author: TheMagnetar
 * Task patrol.
 *
 * Arguments:
 * 0: Group <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_tasks_fnc_handlePatrolState
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_state"];

private _settings = _group getVariable [QEGVAR(core,settings), []];
