/*
 * Author: TheMagnetar
 * Makes a unit patrol a building.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 *
 * Example:
 * [group player] call mai_waypoint_fnc_patrolBuilding
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_unit"];

private _buildingPatrol = _unit getVariable [QGVAR(inBuilding), [false]];

if !(_buildingPatrol # 0) exitWith {};

if (!alive _unit) exitWith {
    _unit setVariable [QGVAR(inBuilding), [false]];
};

_buildingPatrol params ["_inBuilding", "_building", ["_buildingPos", []], ["_waitUntilTime", CBA_missionTime], ["_moving", false], ["_returnLeader", false]];

if (_buildingPos isEqualTo []) exitWith {
systemChat format ["Building pos is []"];
    if (!_returnLeader) then {
        _unit doMove (position leader _unit);
        _unit setVariable [QGVAR(inBuilding), [true, _building, _buildingPos, CBA_missionTime + 60, _moving, true]];
    } else {
        if (CBA_missionTime > _waitUntilTime) then {
            _unit setVariable [QGVAR(inBuilding), [false]];
        };
    };
};
systemChat format ["moving %1", _buildingPos];
if (!_moving) then {
    private _index = floor random (count _buildingPos);
    _unit doMove (_building buildingPos _index);
    _buildingPos deleteAt _index;
    _unit setVariable [QGVAR(inBuilding), [true, _building, _buildingPos, CBA_missionTime + 60, true, _returnLeader]];
} else {
    if (moveToCompleted _unit || {moveToFailed _unit} || {!canMove _unit} || {CBA_missionTime >= _waitUntilTime}) then {
        _unit setVariable [QGVAR(inBuilding), [true, _building, _buildingPos, _waitUntilTime, false, _returnLeader]];
    };
};

