/*
 * Author: TheMagnetar
 * Handle patrol building state
 *
 * Arguments:
 * 0: Group <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [nearestBuilding player] call mai_building_fnc_moveInBuilding
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group"];

private _allUnitsFinished = true;
{
    private _inBuilding = (_x getVariable [QGVAR(building), [false]]) # 0;

    if (_inBuilding && {_x getVariable [QEGVAR(waypoint,waitTime), CBA_missionTime] < CBA_missionTime}) then {
        if (vehicle _x == _x) then {
            doGetOut _x;
            _x setVariable [QEGVAR(waypoint,waitTime), CBA_missionTime + 3];
        } else {
            _x call FUNC(patrolBuilding);
        };
        _allUnitsFinished = false;
    };
} forEach (units _group);

if (_allUnitsFinished) then {

    [_settings, "taskState", "patrol"] call CBA_fnc_hashSet;
    [_settings, "waitUntil", CBA_missionTime + 10] call CBA_fnc_hashGet;
    _group lockWP false;
};
