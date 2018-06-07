/*
 * Author: TheMagnetar
 * Move the some of all the unitss of the group to the near buildings.
 *
 * Arguments:
 * 0: Group <OBJECT> (default: objNull)
 * 1: Perform patrol <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [nearestBuilding player] call mai_waypoint_fnc_moveInBuilding
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", ["_patrol", true]];

private _unitsToMove = [];
private _rejectedUnits = [];

// Exclude the leader in patrolling the buildings
private _leader = leader _group;
private _units = (units _group) deleteAt ((units _group) find _leader);

{
    if (_x isKindOf "Man" && {alive _x} && {unitReady _x} && {_x == vehicle _x} && {canmove _x} && {canstand _x}) then {
        _unitsToMove pushBack _x;
    } else {
        _rejectedUnits pushBack _x;
    };
} foreach (units _group);

if (_unitsToMove isEqualTo []) exitWith {};

private _buildings = [leader _group] call FUNC(getNearBuildings);
if (_buildings isEqualTo []) exitWith {};

private _inBuilding = false;
{
    private _buildingPos = [_x] call FUNC(getBuildingPos);

    if !(_buildingPos isEqualTo []) then {
        private _maxUnits = 2 * ;
        private _assignedUnits = [];
        private _unitCount = 0;
        {
            if (_unitCount == _maxUnits) exitWith {};
            _assignedUnits pushBack _x;
            _unitsToMove deleteAt (_unitsToMove find _x);
            _inBuilding = true;
        } forEach _unitsToMove;

        if !(_assignedUnits isEqualTo []) then {
            if (_patrol) then {
                [_assignedUnits, _x, _buildingPos] call FUNC(patrolBuilding);
            } else {
                [_assignedUnits, _x, _buildingPos] call FUNC(holdBuilding);
            };
        };
    }

    if (_unitsToMove isEqualTo []) exitWith {};    
} forEach _buildings;

if (_inBuilding) then {
    private _settings = _group getVariable [QEGVAR(core,settings), []];
    [_settings, "inBuilding", true] call CBA_fnc_hashSet;
    _group setVariable [QEGVAR(core,settings), _settings, true];
};


