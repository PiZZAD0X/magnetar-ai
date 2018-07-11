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
 * [group player] call mai_tasks_fnc_onEmbarkStateEntered
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_state"];

private _unitsToEmbark = (units _group) select {vehicle _x == _x && {alive _x}};

if (_unitsToEmbark isEqualTo []) exitWith {};

// Allow units to get in
_unitsToEmbark allowGetIn true;

// If units were patrolling on their own, fall back to following the group leader
_unitsToEmbark doFollow (leader _group);

private _vehicle = _group getVariable [QEGVAR(vehicle,assignedVehicle), objNull];

[_vehicle, _unitsToEmbark] call EFUNC(vehicle,getInVehicle);
