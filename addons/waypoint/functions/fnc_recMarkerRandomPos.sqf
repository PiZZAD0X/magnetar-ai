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

private _xRnd = _centerX + _randX;
private _yRnd = _centerY + _randY;

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
