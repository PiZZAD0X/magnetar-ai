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
private _unitsToStop = _disembarkUnits select {(_x distance2D (_x getVariable [QGVAR(_checkedPos), [0,0,0]]) < 1) && {!(_x getVariable [QGVAR(ready), false])}};

{
    _x setUnitPos "MIDDLE";
    doStop _x;
    _x setVariable [QGVAR(ready), true];
    _x setVariable [QGVAR(waitUntil), CBA_missionTime + 5 + random 5];
} forEach _unitsToStop;

private _readyUnits = _disembarkUnits select {CBA_missionTime > (_x getVariable [QGVAR(waitUntil), CBA_missionTime])};

// Wait until all units are in position and waited enough time
if (count _readyUnits != count _disembarkUnits) exitWith {};

{
    _x setVariable [QGVAR(ready), false];
} forEach _disembarkUnits;

systemChat format ["embark embark embark embark embark"];
[QEGVAR(tasks,embark), _group] call CBA_fnc_localEvent;
/*
_group setVariable [QEGVAR(tasks,perimeterSettings), getPos (_group getVariable QGVAR(assignedVehicle)), 75];
*/
