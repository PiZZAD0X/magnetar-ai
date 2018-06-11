/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Marker <STRING> (Default: "")
 *
 * Return Value:
 * Random point <ARRAY> ([0,0] if invalid marker)
 *
 * Example:
 * ["marker"] call mai_waypoint_fnc_markerRandomPos
 *
 * Public: No
 */
#include "script_component.hpp"

params [["_marker", ""], ["_condition", [false, true, false]], ["_checkRadius", [0, 0, ""]]];
systemChat format ["marker %1", _marker];
if (_marker isEqualTo "") exitWith {[0,0]};

private _center = getMarkerPos _marker;
private _centerX = abs(_center # 0);
private _centerY = abs(_center # 1);

private _markerSize = getMarkerSize _marker;
private _sizeX = _markerSize # 0;
private _sizeY = _markerSize # 1;
private _markerDir = markerDir _marker;
private _xRnd = 0;
private _yRnd = 0;

private "_rndFunction";
if (toLower (markerShape _marker) == "rectangle") then {
    _rndFunction = missionNamespace getVariable [QGVAR(recMarkerRandomPos)];
} else {
    _rndFunction = missionNamespace getVariable [QGVAR(elipMarkerRandomPos)];
};

private _tries = 0;
private _targetPos = [];
_checkRadius params [["_minRadius", 0], ["_maxRadius", 0], ["_vehicleType", ""]];
_condition params [["_allowWater", false], ["_allowLand", true], ["_forceRoads", false]];

while {_tries < 25} do {
    _trialPos = [_sizeX, _sizeY, _centerX, _centerY, _markerDir] call _rndFunction;
    _found = false;

    if (_allowWater && {surfaceIsWater _trialPos}) then {
        _found = true;
        _tries = 50;
    };

    if (_allowLand && {!surfaceIsWater _trialPos}) then {
        if (_forceRoads) then {
            private _roads = (_trialPos nearRoads 250);
            if !(_roads isEqualTo []) then {
                _targetPos = getpos (_roads select 0);
                _found = true
            };
        } else {
            _found = true;
        };
    };

    if (_allowWater && {_allowLand} && {!_forceRoads}) then {
        _tries = 50;
    }

    if (_found) then {
        private _checkedPos = [];
        if (_vehicle isEqualTo "") then {
            _checkedPos = _trialPos findEmptyPosition [_minRadius, _maxRadius];
        } else {
            _checkedPos = _trialPos findEmptyPosition [_minRadius, _maxRadius, ""];
        };

        if (_checkedPos isEqualTo [] || {!(_checkedPos inArea _marker)}) then {
            _tries = _tries + 1;
        } else {
            _targetPos = _checkedPos;
            _tries = 50;
        }
    } else {
        _tries = _tries + 1;
    };
};

_targetPos
