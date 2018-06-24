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

private _targetPos = waypointPosition [_group, 0];
private _reachedDistance = [_settings, "reachedDistance"] call CBA_fnc_hashGet;
private _checkingDistance = [_settings, "checkingDistance"] call CBA_fnc_hashGet;
private _buildingCheckTime = _group getVariable [QGVAR(buildingCheckTime), CBA_missionTime];
//private _taskTimeStart = [_settings, "taskTimeStart"] call CBA_fnc_hashGet;

private _leader = leader _group;
private _distance = _leader distance _targetPos;

// Search for a vehicle
if (_distance > _reachedDistance && {vehicle _leader == _leader} && {[_settings, "allowVehicles"] call CBA_fnc_hashGet}) then {

};

// Start patrolling buildings if units are near the waypoint
private _unitType = [_settings, "type"] call CBA_fnc_hashGet;
private _inBuilding = _group getVariable [QGVAR(inBuilding), false];

//systemChat format ["Patrol Building %1 %2 %3 %4 %5 %6", _unitType in ["infantry", "wheeled"], _distance < _checkingDistance, [_settings, "patrolBuildings"] call CBA_fnc_hashGet,!_inBuilding, random 100 < 70, unitType in ["infantry", "wheeled"] && {_distance < _checkingDistance} && {[_settings, "patrolBuildings"] call CBA_fnc_hashGet} && {!_inBuilding} && {random 100 < 70}];
private _checkProbability = (1 - _distance/(_group getVariable [QGVAR(distance), _leader distance _targetPos])*100) min 70;
if (_unitType in ["infantry", "wheeled"] && {CBA_missionTime > _buildingCheckTime} && {_distance < _checkingDistance} && {[_settings, "patrolBuildings"] call CBA_fnc_hashGet} && {!_inBuilding} && {random 100 < _checkProbability}) then {
    [QGVAR(patrolBuildings), _group] call CBA_fnc_localEvent;
};

// Waypoint completed
if (_distance < _reachedDistance) then { // || {(CBA_missionTime - _taskTimeStart) > _taskTimeOut}) then {
    if ([_settings, "waitAtWaypoint"] call CBA_fnc_hashGet) then {
        _group setVariable [QGVAR(waitUntil), CBA_missionTime + 30 + random 30];
    } else {
        [QGVAR(generateWaypoint), _group] call CBA_fnc_localEvent;
    };
};
