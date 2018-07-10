/*
 * Author: TheMagnetar
 * Handles state entered
 *
 * Arguments:
 * 0: Building <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [nearestBuilding player] call mai_building_fnc_getBuildingPositions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_state"];

private _inBuilding = [_group] call FUNC(moveInBuilding);
if (_inBuilding) then {
    _group setVariable [QEGVAR(tasks,inBuilding), true];

    // Lock the waypoint and add a new one
    _group lockWP true;
    private _leader = leader _group;
    private _wp = _group addWaypoint [getPos _leader, 0, currentWaypoint _group];
    private _comp = format ["this setFormation '%1'; this setBehaviour '%2'; deleteWaypoint [group this, currentWaypoint (group this)];", formation _group, behaviour _leader];
    _wp setWaypointStatements ["true", _comp];

    _group setBehaviour "Combat";
};
