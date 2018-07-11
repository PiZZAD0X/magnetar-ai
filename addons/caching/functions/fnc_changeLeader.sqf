/*
 * Author: TheMagnetar
 * Handles changing the leader while unit is cached
 *
 * Arguments:
 * 0: Group <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group1] call mai_cache_fnc_changeLeader
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group"];

private _leader = leader _group;
_group setVariable [QGVAR(leader), _leader, true];

if !(simulationEnabled _leader) then {
    _leader enableSimulationGlobal false;
    _leader hideObjectGlobal false;
}

[QGVAR(cache), _group] call CBA_fnc_localEvent;
