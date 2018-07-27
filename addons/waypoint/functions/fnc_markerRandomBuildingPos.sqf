/*
 * Author: TheMagnetar
 * Returns a random building position in a marker.
 *
 * Arguments:
 * 0: Marker <STRING> (default: "")
 * 1: Condition <ARRAY> (default: [false, true, false])
 *  0: Allow waypoint on water <BOOL>
 *  1: Allow waypoint on land <BOOL>
 *  2: Force waypoint on roads <BOOL>
 * 2: Check radius for a valid unit position <ARRAY> (default: [0, 50, ""])
 *  0: Min radius <NUMBER>
 *  1: MAx radius <NUBMER>
 *  2: Object classname <STRING>
 *
 * Return Value:
 * Random point <ARRAY> ([0,0] if invalid marker)
 *
 * Example:
 * ["marker"] call mai_waypoint_fnc_markerRandomBuildingPos
 *
 * Public: No
 */
#include "script_component.hpp"

// Get all buildings
params ["_numPos", "_position", "_filter", ["_suffle", true]];

private _center = 0;
private _radius = 0;

if (_position isEqualType "") then {
    _center = getMarkerPos _marker;
    (getMarkerSize _marker) params ["_radiusX", "_radiusY"];
    _radius = _radiusX max _radiusY;
} else {
    _center = _position # 0;
    _radius = _position # 1;
};


private _buildings = [_center, _radius] call EFUNC(building,getNearBuildings);
private _filteredBuildings = [_buildings, _filter] call EFUNC(building,filterBuildings);

if (_filteredBuildings isEqualTo []) exitWith {[]};

_building = ([_filteredBuildings, 5] call EFUNC(core,shuffleArray)) # 0;

_freePos = _building getVariable [QGVAR(freePositions), -1];

if (_freePos == -1) then {
    _freePos = _building buildingPos -1;
};

private _returnPositions = [];

if (count _freePos < _numPos) then {
    _building setVariable [QGVAR(freePositions), []];
    _returnPositions append _freePos;
    _returnPositions append ([_numPos - (count _freePos)), [getPos _building, 25], _filter, false] call FUNC(markerRandomBuildingPos);
} else {
    _returnPositions append (([_freePos, 5] call FUNC(suffleArray)) select [1, _numPos]);
    {
        _freePos deleteAt (_freePos findIf _x);
    } forEach _returnPositions;

    _building setVariable [QGVAR(freePositions), _freePos];
};

_returnPositions
