/*
 * Author: TheMagnetar
 * Moves all units to the specified positions
 *
 * Arguments:
 * 0: Units <ARRAY>
 * 1: Positions <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group1] call mai_core_fnc_moveUnitsToPositions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_units", "_position"];

if (count _units != count _positions) exitWith {
    ERROR("Different number of units (%1) and positions (%2)",count _units, count _positions);
};

{
    x setPos (_positions # _forEachIndex);
} forEach _units;
