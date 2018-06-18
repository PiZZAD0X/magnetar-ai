/*
 * Author: TheMagnetar
 * Returns if a building was checked by a group in the last x secods.
 *
 * Arguments:
 * 0: Marker <STRING> (Default: "")
 *
 * Return Value:
 * Random point <ARRAY> ([0,0] if invalid marker)
 *
 * Example:
 * ["marker"] call mai_building_fnc_markerRandomPos
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_building"];

private _checkedBuildings = missionNamespace getVariable [QGVAR(checkedBuildings), []];

private _index = -1;
{
    if ((_x # 0) isEqualTo _building) exitWith { _index = _forEachIndex; };
} forEach _checkedBuildings;

_index != -1 && {_x # 1 + 300 >= CBA_missionTime}
