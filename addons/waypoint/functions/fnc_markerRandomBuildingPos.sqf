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
 * ["marker"] call mai_waypoint_fnc_markerRandomPos
 *
 * Public: No
 */
#include "script_component.hpp"

// Get all buildings
params ["_numPos", "_marker", "_filter"];

private _center = getMarkerPos _marker;
(getMarkerSize _marker) params ["_radiusX", "_radiusY"];

private _buildings = [_center, _radiusX max _radiusY] call EFUNC(building,getNearBuildings);
private _filteredBuildings = [_buildings, _filter] call EFUNC(building,filterBuildings);

// Find first buildings that allow a certain number of positions
