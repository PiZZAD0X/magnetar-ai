/*
 * Author: TheMagnetar
 * Generates a set of waypoints for perimeter patrolling.
 *
 * Arguments:
 * 0: Group <OBJECT> (default: [])
 * 1: Center of the waypoint patrol <ARRAY>
 * 2: Radius of the waypoint patrol <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_waypoint_fnc_generatePerimeterWaypoint
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_group", objNull], "_center", "_radius"];

// Taken from CBA_fnc_taskPatrol.sqf
private _count = floor (4 + _radius/25);
private _step = 360 / _count;
private _offset = random _step;
private _execStatement = "";

for "_i" from 1 to _count do {
    // Gaussian distribution avoids all waypoints ending up in the center
    private _rad = _radius * random [0.4, 0.75, 1];

    // Alternate sides of circle & modulate offset
    private _theta = (_i % 2) * 180 + sin (deg (_step * _i)) * _offset + _step * _i;

    if (_i == _count) then {
        _execStatement = QUOTE(_group setVariable [ARR_2(QQEGVAR(tasks,patrolFinished), true)]);
    };
    [_group, _center getPos [_rad, _theta], "MOVE", _execStatement] call FUNC(addWaypoint);
};
