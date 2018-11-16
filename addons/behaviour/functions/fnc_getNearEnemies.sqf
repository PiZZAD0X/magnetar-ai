#include "script_component.hpp"
/*
 * Author: TheMagnetar
 * Returns an array of dead bodies within the given distance visible by the unit
 *
 * Arguments:
 * 0: Unit <OBJECT><ARRAY>
 * 1: Radius <NUMBER> (default: -1)
 *
 * Return Value:
 * Array of dead bodies <ARRAY>
 *
 * Example:
 * [player, 100] call mai_behaviour_fnc_getNearEnemies
 *
 * Public: No
 */

params ["_unit", ["_radius", -1]];


private _targets = _unit nearTargets _radius;
