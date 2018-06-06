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
 * [group player] call mai_acre_fnc_generateWaypoint
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_group", objNull], ["_vehicleType", 0], ["_options", []]];

private _marker = _group getVariable [QGVAR(marker), ""];
private _sizeX = (markerSize _marker) # 0;
private _sizeY = (markerSize _marker) # 1;

private _minimumDistance = 2/3*sqrt(_sizeX^2 + _sizeY^2);

switch (_vehicleType) do {
    case INFANTRY: {

    };
    case WHEELED: {

    };
    case ARMORED: {

    };
    case AIR: {

    };
    case BOAT: {

    };
    case DIVER: {

    };
};

private _tries = 0;
private _currentPos = getPos (leader _group);
private _allowWater = false;
private _forceRoads = true;
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

_targetPos
