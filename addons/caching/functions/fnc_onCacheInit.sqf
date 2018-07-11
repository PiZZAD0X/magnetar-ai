/*
 * Author: TheMagnetar
 * Initialises cache functions
 *
 * Arguments:
 * 0: Group <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group1] call mai_cache_fnc_cacheGroup
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group"];

_group setVariable [QGVAR(cached), false, true];
_group setVariable [QGVAR(leader), leader _group, true];
