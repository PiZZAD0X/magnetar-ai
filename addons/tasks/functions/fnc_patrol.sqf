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
        private _targetPos = [_group] call EFUNC(waypoint,generateWaypoint);

        // TODO add support for custom waypoints
        [_settings, "taskState", "patrol"] call CBA_fnc_hashSet;

        // TODO make the reached distance depend on marker size?
        [_settings, "reachedDistance", 10] call CBA_fnc_hashSet;
        [_settings, "checkingDistance", 150] call CBA_fnc_hashSet;

        _changed = true;
    };
    case "patrol"; {
        private _targetPos = waypointPosition [_group, 0];
        private _reachedDistance = [_settings, "reachedDistance"] call CBA_fnc_hashGet;
        private _checkingDistance = [_settings, "checkingDistance"] call CBA_fnc_hashGet;
        private _taskTimeStart = [_settings, "taskTimeStart"] call CBA_fnc_hashGet;
        private _taskTimeOut = [_settings, "taskTimeOut"] call CBA_fnc_hashGet;

        private _leader = leader _group;
        private _distance = _leader distance _targetPos;
        
        // Search for a vehicle
        if (_distance > _reachedDistance && {vehicle _leader == _leader} && {[_settings, "allowVehicles"] call CBA_fnc_hashGet}) then {

        };

        // Start patrolling buildings if units are near the waypoint
        private _unitType = [_settings, "type"] call CBA_fnc_hashGet;
        if (unitType in ["infantry", "wheeled"] && {_distance < _checkingDistance} && {[_settings, "patrolBuildings"] call CBA_fnc_hashGet} && (random 100 < 70)) then {

        };

        // Search for a building to patrol
        if (_distance < _reachedDistance || {(CBA_missionTime - _taskTimeStart) > _taskTimeOut}) then {

            if ([_settings, "waitAtWaypoint"] call CBA_fnc_hashGet) then {
                [_settings, "waitUntil", CBA_missionTime + 30 + random 30] call CBA_fnc_hastSet;
                [_settings, "taskState", "wait"] call CBA_fnc_hashSet;
            } else {
                [_settings, "taskState", "init"] call CBA_fnc_hashSet;
            };
            
            _changed = true;
        };
    };

    case "searchVehicles" : {

    };

    case "patrolBuildings": {

    };

    case "wait": {
        if (CBA_missionTime > [_settings, "waitUntil"] call CBA_fnc_hashGet) then {
            [_settings, "taskState", "init"] call CBA_fnc_hashSet;
            _changed = true;
        }
    };
};

_changed
