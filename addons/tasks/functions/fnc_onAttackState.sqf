/*
 * Author: TheMagnetar
 * Task defend.
 *
 * Arguments:
 * 0: Group <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_tasks_fnc_onAttackState
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group"];

if (!local _leader) exitWith {};

if !(CBA_missionTime >= (_group getVariable [QGVAR(nextCheckTime), CBA_missionTime])) exitWith {};

if ((units _group) findIf {alive _x} == -1) exitWith {deleteGroup _group;};

// Perform the next check in 5 seconds
_group setVariable [QGVAR(nextCheckTime), CBA_missionTime + 5];
