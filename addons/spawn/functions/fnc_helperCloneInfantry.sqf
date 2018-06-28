/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Group to clone <OBJECT>
 * 1: Sleep time between unit creation <NUMBER> (default: 0.05)
 *
 * Return Value:
 * Group <OBJECT>
 *
 * Example:
 * [player] call mai_spawn_fnc_cloneGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_modelGroup", "_cloneGroup", "_position", "_sleep"];

// Generate units
{
    private _type = typeOf _x;
    private _pos = _position findEmptyPosition [0, 50, _type];
    private _unit = _cloneGroup createUnit [typeOf _x, _position, [], 2, "NONE"];
    _unit setSkill (skill _x);

    if (leader _modelGroup == _x) then {
        _cloneGroup selectLeader _unit;
    };

    sleep _sleep;
} forEach (units _modelGroup);
