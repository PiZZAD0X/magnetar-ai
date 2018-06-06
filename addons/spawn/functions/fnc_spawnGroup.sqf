/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Unit array. First position is always the leader <ARRAY> (Default: [])
 * 1: Position <ARRAY>
 * 2: Side <STRING>
 * 3: List of options <STRING> (default [])
 * 4: Sleep time between unit creation <NUMBER> (default: 0.05)
 *
 * Return Value:
 * Group <OBJECT>
 *
 * Example:
 * [player] call mai_spawn_fnc_spawnInfantryGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_units", "_position", "_side", ["_options", []], ["_sleep", 0.05]];

private _grp = createGroup _side;

{
    private _unit = _grp createUnit [_x, _position, [], 2, "NONE"];
    if (_forEachIndex == 0) then {
        _grp setLeader _x;
    };
    sleep _sleep;
} forEach _units;

if !(_options isEqualTo []) then {
    [_grp] call EFUNC(core,handleOptions);
};

_grp
