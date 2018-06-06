/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Unit <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call mai_acre_fnc_spawnInfantryGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_unitPool", "_groupSize", "_position", "_side", ["_options", []], ["_sleep", 0.05]];

_unitPool params ["_leaderPool", "_soldiersPool"];

_options params ["_side"];

private _grp = createGroup _side;
private _leader = _grp createUnit [selectRandom _leaderPool, _position, [], 2, "NONE"];
_grp setLeader _leader;

private _size = 0;
if (isArray _groupSize) then {
    _groupSize params ["_minSize", "_maxSize"];
    _size = _minSize + floor (random (_maxSize - _minSize));
} else {
    _size = _groupSize;
};

{
    // Check if the maximum size of the group has been reached substracting the leader position
    if (_forEachIndex + 1 > (_size -1 )) exitWith {};

    private _unitType = selectRandom _soldiersPool;
    private _unit = _grp createUnit [_unitType, _position, [], 2, "NONE"];
    sleep _sleep;

} forEach _soldiersPool;

if (_options isEqualTo []) then {
    [_grp] call EFUNC(core,handleOptions);
};

_grp
