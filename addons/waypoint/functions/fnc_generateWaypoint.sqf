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

params [["_group", objNull], ["_options", []]];

private _marker = _group getVariable [QGVAR(marker), ""];
private _sizeX = (markerSize _marker) # 0;
private _sizeY = (markerSize _marker) # 1;
private _minimumDistance = 2/3*sqrt(_sizeX^2 + _sizeY^2);

private _settings = _group getVariable [QEGVAR(core,settings), []];

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
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;
private _targetPos = [0, 0, 0];

while {_tries < 50} do {
    private _trialPos = [_marker] call FUNC(markerRandomPos);
    if (_trialPos distance2D _currentPos >= _minimumDistance) then {
        private _found = false;
        if (_allowWater && {surfaceIsWater _trialPos}) then {
            _tries = 50;
            _targetPos = _trialPos;
            _found = true;
        };

        if (_forceRoads) then {
            private _roads = (_trialPos nearRoads 250);
            if !(_roads isEqualTo []) then {
                _targetPos = getpos (_roads select 0);
                _found = true;
            };
        };

        if (!_found) then {
            _tries = _tries + 1;
        };
    } else {
        _tries = _tries + 1;
    };

};

private _waypoint = _group addWaypoint [_targetPos, 0];
_waypoint  setWaypointPosition [_targetPos, 0];

switch ([_settings, "task"] call CBA_fnc_hashGet) do {
    default { _waypoint  setWaypointType "MOVE"; };
};

if ([_settings, "randomBehaviour"] call CBA_fnc_hashGet) then {
    _waypoint setWaypointFormation (selectRandom ([_settings, "formation"] call CBA_fnc_hashGet));
    _waypoint setWaypointSpeed (selectRandom ([_settings, "speed"] call CBA_fnc_hashGet));
    _waypoint setwaypointbehaviour (selectRandom ([_settings, "behaviour"] call CBA_fnc_hashGet));
    _waypoint setwaypointCombatMode (selectRandom ([_settings, "combatMode"] call CBA_fnc_hashGet));
} else {
    _waypoint setWaypointFormation (waypointFormation _group);
    _waypoint setWaypointSpeed (waypointSpeed _group);
    _waypoint setwaypointbehaviour (waypointBehaviour _group);
    _waypoint setwaypointCombatMode (waypointCombatMode _group);
};
//_waypoint  setWaypointLoiterRadius _radius;
_group setCurrentWaypoint _waypoint;

// Delete the old waypoint
private _numWaypoints = count (waypoints _group);
{
    if (_forEachIndex != _numWaypoints - 1) then {
        deleteWaypoint _x;
    };
} forEach (waypoints _group);
