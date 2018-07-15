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
if ((units _group) findIf {alive _x} == -1) exitWith {deleteGroup _group;};

private _leader = leader _group;
private _targetPos = waypointPosition [_group, 0];

if (!local _leader) exitWith {
    _group setVariable [QEGVAR(tasks,waitUntil), _group getVariable [QEGVAR(tasks,waitUntil), CBA_missionTime], true];
    _group setVariable [QEGVAR(tasks,distance), _group getVariable [QGVAR(distance), (getPos (leader _group)) distance2D _targetPos], true];
    _group setVariable [QEGVAR(tasks,buildingCheckTime), _group getVariable [QEGVAR(tasks,buildingCheckTime), CBA_missionTime], true];
    _group setVariable [QGVAR(inBuilding), _group getVariable [QGVAR(inBuilding), false], true];
};

private _allUnitsFinished = true;
{
    private _inBuilding = (_x getVariable [QGVAR(inBuilding), [false]]) # 0;
    if (_inBuilding) then {
        _x call FUNC(patrolBuilding);
        _allUnitsFinished = false;
    };
} forEach (units _group);

if (_allUnitsFinished) then {
    (units _group) doFollow _leader;
    _group setVariable [QEGVAR(tasks,finishedBuildingPatrol), CBA_missionTime + 10];
    _group lockWP false;

    [QEGVAR(tasks,doTask), _group] call CBA_fnc_localEvent;
};
