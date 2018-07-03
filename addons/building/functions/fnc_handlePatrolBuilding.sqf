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
 * [nearestBuilding player] call mai_building_fnc_handlePatrolBuilding
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group"];

if (units _group select {alive _x} isEqualTo []) exitWith {deleteGroup _group;};

if (!local (leader _group)) exitWith {
    _group setVariable [QGVAR(tasks,waitUntil), _group getVariable [QGVAR(waitUntil), CBA_missionTime], true];
    _group setVariable [QGVAR(tasks,distance), _group getVariable [QGVAR(distance), (getPos (leader _group)) distance2D _targetPos], true];
    _group setVariable [QGVAR(tasks,buildingCheckTime), _group getVariable [QGVAR(buildingCheckTime), CBA_missionTime], true];
    _group setVariable [QGVAR(tasks,inBuilding), _group getVariable [QGVAR(inBuilding), false], true];
};

private _allUnitsFinished = true;
{
    private _inBuilding = (_x getVariable [QGVAR(building), [false]]) # 0;

    if (_inBuilding && {_x getVariable [QGVAR(disembarkTime), CBA_missionTime] < CBA_missionTime}) then {
        if (vehicle _x == _x) then {
            doGetOut _x;
            _x setVariable [QGVAR(disembarkTime), CBA_missionTime + 3];
        } else {
            _x call FUNC(patrolBuilding);
        };
        _allUnitsFinished = false;
    };
} forEach (units _group);

if (_allUnitsFinished) then {
    _group setVariable [QEGVAR(tasks,finishedBuildingPatrol), CBA_missionTime + 10];
    _group lockWP false;

    [QEGVAR(tasks,doTask), _group] call CBA_fnc_localEvent;
};
