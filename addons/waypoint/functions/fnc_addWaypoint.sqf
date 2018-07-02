/*
 * Author: TheMagnetar
 * Generates a waypoint.
 *
 * Arguments:
 * 0: Group <OBJECT> (default: [])
 * 1: Target Position <ARRAY>
 * 2: Waypoint type <STRING> (default: "")
 *
 * Return Value:
 * Waypoint <WAYPOINT>
 *
 * Example:
 * [group player, ] call mai_waypoint_fnc_generateWaypoint
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_group", "_targetPos", ["_waypointType", ""]];

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _waypoint = _group addWaypoint [_targetPos, 0];

_waypoint setWaypointPosition [_targetPos, 0];

if (_waypointType isEqualTo "") then {
    switch ([_settings, "task"] call CBA_fnc_hashGet) do {
        default { _waypointType = "MOVE"; };
    };
};

_waypoint setWaypointType _waypointType;

if ([_settings, "randomBehaviour"] call CBA_fnc_hashGet) then {
    _waypoint setWaypointFormation (selectRandom ([_settings, "formation"] call CBA_fnc_hashGet));
    _waypoint setWaypointSpeed (selectRandom ([_settings, "speed"] call CBA_fnc_hashGet));
    _waypoint setwaypointBehaviour (selectRandom ([_settings, "behaviour"] call CBA_fnc_hashGet));
    _waypoint setwaypointCombatMode (selectRandom ([_settings, "combatMode"] call CBA_fnc_hashGet));
} else {
    _waypoint setWaypointFormation "NO CHANGE";
    _waypoint setWaypointSpeed "UNCHANGED";
    _waypoint setwaypointbehaviour "UNCHANGED";
    _waypoint setwaypointCombatMode "NO CHANGE";
};

//_waypoint setWaypointCompletionRadius ([_settings, [_settings, "reachedDistance"]] call CBA_fnc_hashGet);
_waypoint setWaypointStatements ["true", [_settings, "execWaypoint"] call CBA_fnc_hashGet];

_waypoint
