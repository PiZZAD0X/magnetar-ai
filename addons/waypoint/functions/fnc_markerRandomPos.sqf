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
 * [player] call mai_acre_fnc_markerRandomPos
 *
 * Public: No
 */
#include "script_component.hpp"

params [["_marker", ""]];
systemChat format ["test"];
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

if (toLower (markerShape _marker) == "rectangle") then {
    private _randX = random (_sizeX * 2) - _sizeX;
    private _randY = random (_sizeY * 2) - _sizeY;

    _xRnd = _centerX + _randX;
    _yRnd = _centerY + _randY;
} else {
    // Apply inverse CFG technique to get a random angle and radius
    private _rnd = random 1;
   // private _theta = atan2 (_sizeX);
/*    private _theta = atan2 (_sizeY/_sizeX * tan(2*pi*_rnd));*/
    private _maxRadius = _sizeX * _sizeY / sqrt( (_sizeY*cos(_theta))^2 + (_sizeX*sin(_theta))^2);
    private _radius = _maxRadius*sqrt(random 1);

    _xRnd = _centerX + _radius*cos(_theta);
    _yRnd = _centerY + _radius*sin(_theta);
};


private ["_xCoord", "_yCoord"];

if (_markerDir != 0) then {
    // Apply 2D rotation matrix
    _xCoord = cos(_markerDir)*_xRnd - sin(_markerDir)*_yRnd;
    _yCoord = sin(_markerDir)*_xRnd + cos(_markerDir)*_yRnd;
} else {
    _xCoord = _xRnd;
    _yCoord = _yRnd;
};

[_xCoord, _yCoord];
