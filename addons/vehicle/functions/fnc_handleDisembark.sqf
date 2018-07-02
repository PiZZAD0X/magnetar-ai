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

params ["_group"];

if (!local _group) exitWith {};

private _disembarkUnits = (units _group) select {alive _x && {_x getVariable [QGVAR(markedForDisembark), false]}};
if (_disembarkUnits isEqualTo []) exitWith {};

// Select units that are ready
private _movingUnits = _disembarkUnits select {unitReady _x || {!stopped _x}};
private _stoppedUnits = _disembarkUnits select {stopped _x};

{
    _x setUnitPos "MIDDLE";
    doStop _x;
    _x setVariable [QGVAR(waitUntil), CBA_missionTime + 5 + random 5];
} forEach _movingUnits;

private _readyUnits = _stoppedUnits select {CBA_missionTime > (_x getVariable [QGVAR(waitUntil), CBA_missionTime])};

// Wait until all units are in position and waited enough time
if (count _readyUnits != count _disembarkUnits) exitWith {};

{
    _x setVariable [QGVAR(markedForDisembark), false];
} forEach _readyUnits;

[QEGVAR(tasks,embark), _group] call CBA_fnc_localEvent;
/*
_group setVariable [QEGVAR(tasks,perimeterSettings), getPos (_group getVariable QGVAR(assignedVehicle)), 75];
*/
