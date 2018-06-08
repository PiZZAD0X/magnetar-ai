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

switch (_taskState) do {
    case "init" : {
        private _targetPos = [_group] call EFUNC(waypoint,generateWaypoint);
        // TODO add support for custom waypoints
        [_settings, "taskState", "patrol"] call CBA_fnc_hashSet;
        private _marker = [_settings, "marker"] call CBA_fnc_hashGet;
        [_settings, "_reachedDistance", 10] call CBA_fnc_hashSet;
    };
    case "patrol"; {
        private _targetPos = waypointPosition [_group, 0];
        private _reachedDistance = [_settings, "reachedDistance"] call CBA_fnc_hashGet;
        private _taskTimeStart = [_settings, "taskTimeStart"] call CBA_fnc_hashGet;
        private _taskTimeOut = [_settings, "taskTimeOut"] call CBA_fnc_hashGet;

        // Search for a vehicle

        if (((leader _group) distance _targetPos) < _reachedDistance || {(CBA_missionTime - _taskTimeStart) > _taskTimeOut}) then {
            [_settings, "taskState", "init"] call CBA_fnc_hashSet;
        };
    };

    case "patrolBuildings": {

    };
};

_group setVariable [QEGVAR(core,settings), _settings, true];
