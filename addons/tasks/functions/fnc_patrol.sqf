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
 * [group player] call mai_tasks_fnc_patrol
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group"];

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _taskState = [_settings, "taskState"] call CBA_fnc_hashGet;
private _changed = false;

switch (_taskState) do {
    case "init" : {
        // TODO add support for custom waypoints
        [_settings, "taskState", "patrol"] call CBA_fnc_hashSet;

        // TODO make the reached distance depend on marker size?
        [_settings, "reachedDistance", 10] call CBA_fnc_hashSet;
        [_settings, "checkingDistance", 150] call CBA_fnc_hashSet;
        [_settings, "behaviour", ["safe"]] call CBA_fnc_hashSet;
        [_settings, "speed", ["limited"]] call CBA_fnc_hashSet;
        if ([_settings, "forceRoads"] call CBA_fnc_hashGet) then {
            (leader _group) forceFollowRoad true;
        };
        _group setBehaviour "SAFE";
        _group setSpeedMode "LIMITED";

        systemChat format ["task init %1", [_settings, "marker"] call CBA_fnc_hashGet];
        private _targetPos = [_group, [_settings, "marker"] call CBA_fnc_hashGet] call EFUNC(waypoint,generateWaypoint);
        _changed = true;
    };

    case "generateWaypoint": {
        private _targetPos = [_group, [_settings, "marker"] call CBA_fnc_hashGet] call EFUNC(waypoint,generateWaypoint);
        [_settings, "taskState", "patrol"] call CBA_fnc_hashSet;
        _changed = true;
    };
    case "patrol": {
        private _targetPos = waypointPosition [_group, 0];
        private _reachedDistance = [_settings, "reachedDistance"] call CBA_fnc_hashGet;
        private _checkingDistance = [_settings, "checkingDistance"] call CBA_fnc_hashGet;
        //private _taskTimeStart = [_settings, "taskTimeStart"] call CBA_fnc_hashGet;

        private _leader = leader _group;
        private _distance = _leader distance _targetPos;

        // Search for a vehicle
        if (_distance > _reachedDistance && {vehicle _leader == _leader} && {[_settings, "allowVehicles"] call CBA_fnc_hashGet}) then {

        };

        // Start patrolling buildings if units are near the waypoint
        private _unitType = [_settings, "type"] call CBA_fnc_hashGet;
        private _inBuilding = [_settings, "inBuilding"] call CBA_fnc_hashGet;

        if (_inBuilding) then {
            if (CBA_missionTime > [_settings, "waitUntil"] call CBA_fnc_hashGet) then {
                [_settings, "inBuilding", false] call CBA_fnc_hashSet;
                _inBuilding = false;
                (leader _group) enableAI "PATH";
            };
        };

        //systemChat format ["Patrol Building %1 %2 %3 %4 %5 %6", _unitType in ["infantry", "wheeled"], _distance < _checkingDistance, [_settings, "patrolBuildings"] call CBA_fnc_hashGet,!_inBuilding, random 100 < 70, unitType in ["infantry", "wheeled"] && {_distance < _checkingDistance} && {[_settings, "patrolBuildings"] call CBA_fnc_hashGet} && {!_inBuilding} && {random 100 < 70}];
        if (_unitType in ["infantry", "wheeled"] && {_distance < _checkingDistance} && {[_settings, "patrolBuildings"] call CBA_fnc_hashGet} && {!_inBuilding} && {random 100 < 70}) then {
            systemChat format ["Patrol Building"];
            private _inBuilding = [_group] call FUNC(moveInBuilding);
            if (_inBuilding) then {
                [_settings, "taskState", "patrolBuildings"] call CBA_fnc_hashSet;
                [_settings, "inBuilding", _inBuilding] call CBA_fnc_hashSet;
            };
        };

        // Waypoint completed
        if (_distance < _reachedDistance) then { // || {(CBA_missionTime - _taskTimeStart) > _taskTimeOut}) then {

            if ([_settings, "waitAtWaypoint"] call CBA_fnc_hashGet) then {
                [_settings, "waitUntil", CBA_missionTime + 30 + random 30] call CBA_fnc_hashSet;
                [_settings, "taskState", "wait"] call CBA_fnc_hashSet;
                systemChat format ["task wait"];
            } else {
                [_settings, "taskState", "generateWaypoint"] call CBA_fnc_hashSet;
                systemChat format ["generating new waypoint"];
            };

            _changed = true;
        };
    };

    case "searchVehicles" : {

    };

    case "patrolBuildings": {
        (leader _group) disableAI "PATH";
        private _allUnitsFinished = true;
        {
            private _inBuilding = (_x getVariable [QEGVAR(waypoint,building), [false]]) # 0;

            if (_inBuilding) then {
                if (vehicle _x == _x) then {
                    doGetOut _x;
                    _x setVariable [QEGVAR(waypoint,waitTime), CBA_missionTime + 3];
                } else {
                    _x call EFUNC(waypoint,patrolBuilding);
                };
                _allUnitsFinished = false;
            };
        } forEach (units _group);

        if (_allUnitsFinished) then {
            [_settings, "taskState", "patrol"] call CBA_fnc_hashSet;
            [_settings, "waitUntil", CBA_missionTime + 10] call CBA_fnc_hashGet;
        };
    };

    case "wait": {
        if (CBA_missionTime > [_settings, "waitUntil"] call CBA_fnc_hashGet) then {
            [_settings, "taskState", "generateWaypoint"] call CBA_fnc_hashSet;
            _changed = true;
        }
    };
};

_changed
