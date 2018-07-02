/*
 * Author: TheMagnetar
 * Disembark units from a vehicle.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Distance <NUMBER> (default )
 *
 * Return Value:
 * Nearest vehicles suitable for the group
 *
 * Example:
 * [leader group player] call mai_vehicle_fnc_getNearVehicles
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_state"];

if (!local _group) exitWith {};

private _vehicle = _group getVariable [QEGVAR(vehicle,assignedVehicle), objNull];
if (isNull _vehicle) exitWith {
    [QEGVAR(tasks,generateWaypoint), _group] call CBA_fnc_localEvent;
};

private _allUnitsEmbarked = true;
{
    if ((vehicle _x == _x) && {alive _x}) exitWith {
        _allUnitsEmbarked = false;
    };
} forEach (units _group);

if (_allUnitsEmbarked) then {
    [QEGVAR(tasks,generateWaypoint), _group] call CBA_fnc_localEvent;
};
