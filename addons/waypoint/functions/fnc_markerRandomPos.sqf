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

params [["_marker", ""], ["_condition", [false, true, false]], ["_checkRadius", [0, 50, ""]]];

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
    _rndFunction = missionNamespace getVariable QFUNC(recMarkerRandomPos);
} else {
    _rndFunction = missionNamespace getVariable QFUNC(elipMarkerRandomPos);
};

private _tries = 0;
private _targetPos = [];
_checkRadius params [["_minRadius", 0], ["_maxRadius", 0], ["_vehicleType", ""]];
_condition params [["_allowWater", false], ["_allowLand", true], ["_forceRoads", false]];

while {_tries < 50} do {
    private _trialPos = [_sizeX, _sizeY, _centerX, _centerY, _markerDir] call _rndFunction;
    private _found = false;

    if (_allowWater && {surfaceIsWater _trialPos}) then {
        _found = true;
    };

    if (_allowLand && {!surfaceIsWater _trialPos}) then {
        if (_forceRoads) then {
            private _roads = (_trialPos nearRoads 50);
            if !(_roads isEqualTo []) then {
                {
                    _trialPos = getPos (selectRandom _roads);
                    if ((_trialPos inArea _marker)) exitWith {_found = true};
                } forEach _roads;
            };
        } else {
            _found = true;
        };
    };

    if (_allowWater && {_allowLand} && {!_forceRoads}) then {
        _found = true;
    };

    if (_found) then {
        private _checkedPos = [];
        if (_vehicleType isEqualTo "") then {
            _checkedPos = _trialPos findEmptyPosition [_minRadius, _maxRadius];
        } else {
            _checkedPos = _trialPos findEmptyPosition [_minRadius, _maxRadius, _vehicleType];
        };

        if (_checkedPos isEqualTo [] || {!(_checkedPos inArea _marker)}) then {
            _tries = _tries + 1;
            _found = false;
        } else {
            _targetPos = _checkedPos;
            _tries = 50;
        };
    } else {
        _tries = _tries + 1;
    };
};
/*
systemChat format ["%1", _targetPos];
private _markerName = format ["marker_%1", CBA_missionTime];
private _marker = createMarker [_markerName, _targetPos];
_markerName setMarkerShape "icon";
_markerName setMarkerType "hd_dot";
_markerName setMarkerColor "colorGreen";*/
_targetPos
