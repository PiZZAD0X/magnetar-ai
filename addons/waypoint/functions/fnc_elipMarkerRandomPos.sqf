/*
 * Author: TheMagnetar
 * Random position on a rectangular marker.
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

params ["_sizeX", "_sizeY", "_centerX", "_centerY", "_markerDir"];

private _randX = random (_sizeX * 2) - _sizeX;
private _randY = random (_sizeY * 2) - _sizeY;

// Apply inverse CFG technique to get a random angle and radius
private _rnd = (random 1) / 4;
private _theta = (_sizeY * tan (_rnd*360)) atan2 _sizeX;

private _v = random 1;

if (_v >= 0.25 && _v < 0.5) then {_theta = 180 - _theta};
if (_v >= 0.5 && _v < 0.75) then {_theta = 180 + _theta};
if (_v >=  0.75) then {_theta = -_theta};

private _maxRadius = _sizeX * _sizeY / sqrt( (_sizeY*cos(_theta))^2 + (_sizeX*sin(_theta))^2);
private _radius = _maxRadius*sqrt(random 1);

private _xRnd = _centerX + _radius*cos(_theta);
private _yRnd = _centerY + _radius*sin(_theta);

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
