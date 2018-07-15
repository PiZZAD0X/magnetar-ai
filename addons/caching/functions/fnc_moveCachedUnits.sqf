/*
 * Author: TheMagnetar
 * Moves cached unit close to leader positions so that they can be affected by explosions or artillery fire.
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

{
    if (!simulationEnabled _x && {_vehicle _x == _x}) then {
        _x setPos (formationPosition _x);
    };
} forEach (units _group);

