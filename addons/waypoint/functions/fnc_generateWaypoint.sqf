/*
 * Author: TheMagnetar
 * Generates a waypoint.
 *
 * Arguments:
 * 0: Group <OBJECT> (default: [])
 * 1: Vehicle type <NUMBER> (default: 0)
 * 1: List of options <ARRAY> (default: [])
 *
 * Return Value:
 * Waypoint successful <BOOL>
 *
 * Example:
 * [group player] call mai_waypoint_fnc_generateWaypoint
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_group", objNull], "_marker", ["_options", []]];

if (!local _group) exitWith {};

private _settings = _group getVariable [QEGVAR(core,settings), []];
//systemChat format ["marker %1", _marker];
private _sizeX = (markerSize _marker) # 0;
private _sizeY = (markerSize _marker) # 1;
private _minimumDistance = 2/3*sqrt(_sizeX^2 + _sizeY^2);

if (_settings isEqualTo []) exitWith {
    WARNING_1("Group %1 defined without configuration",_settings);
};

switch ([_settings, "type"] call CBA_fnc_hashGet) do {
    case "infantry": {

    };
    case "wheeled": {

    };
    case "armored": {

    };
    case "air": {

    };
    case "boat": {

    };
};

private _tries = 0;
private _currentPos = getPos (leader _group);
private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;
private _targetPos = _currentPos;

// Delete all waypoints
[_group] call FUNC(clearWaypoints);
_targetPos = _currentPos;
while {_tries < 50} do {
    private _trialPos = [_marker, [_allowWater, _allowLand, _forceRoads]] call FUNC(markerRandomPos);

    TRACE_3("waypoint at %1. Minimum distance %2. Greater than minimum distance %3",_trialPos,_minimumDistance,_trialPos distance2D _currentPos >= _minimumDistance);

    if (_trialPos distance2D _currentPos >= _minimumDistance) then {
        _targetPos = _trialPos;
        _tries = 50;
    } else {
        _tries = _tries + 1;
    };
};

private _waypoint = _group addWaypoint [_targetPos, 0];
_waypoint setWaypointPosition [_targetPos, 0];

switch ([_settings, "task"] call CBA_fnc_hashGet) do {
    default { _waypoint  setWaypointType "MOVE"; };
};

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

_group setCurrentWaypoint _waypoint;

if (EGVAR(core,debugEnabled)) then {
    private _markerName = format ["marker_%1", CBA_missionTime];
    private _marker = createMarker [_markerName, _targetPos];
    _markerName setMarkerShape "icon";
    _markerName setMarkerType "hd_dot";
    _markerName setMarkerColor "colorRed";
};

_targetPos
