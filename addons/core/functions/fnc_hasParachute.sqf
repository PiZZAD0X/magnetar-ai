/*
 * Author: TheMagnetar
 * Returns wether a unit has a parachute equipped
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Unit has a rebreather <BOOL>
 *
 * Example:
 * [player] call mai_core_fnc_hasParachute
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

_backpack = backpack _unit;

_backpack isKindOf "B_Parachute"
