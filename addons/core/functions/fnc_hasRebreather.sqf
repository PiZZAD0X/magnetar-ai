/*
 * Author: TheMagnetar
 * Returns wether a unit has a rebreather equipped
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Unit has a rebreather <BOOL>
 *
 * Example:
 * [player] call mai_core_fnc_hasRebreather
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

_vest = vest _unit;

_vest isKindOf "V_RebreatherB"
