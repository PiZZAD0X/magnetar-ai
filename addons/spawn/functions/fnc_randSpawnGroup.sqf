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
 * [player] call mai_spawn_fnc_spawnInfantryGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_unitPool", "_groupSize", "_marker", ["_sleep", 0.05]];

private _leaderPool = getArray ("CfgGroupCompositions" >> _unitPool >> "leaders");
private _unitPool = getArray ("CfgGroupCompositions" >> _unitPool >> "units");
private _side = getText ("CfgGroupCompositions" >> _unitPool >> "side");

private _grp = createGroup _side;
private _leaderUnit = selectRandon _leaderPool;
private _position = [_marker, [false, true, false], [0, 50, typeOf _leaderUnit]] call EFUNC(waypoint,markerRandomPos);
private _leader = _grp createUnit [, _position, [], 2, "FORM"];
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
    private _unit = selectRandom _unitPool;

    private _position = _targetPos findEmptyPosition [0, 60, typeOf _unit];
    private _unit = _grp createUnit [_unit, _position, [], 2, "FORM"];
    sleep _sleep;

} forEach _unitPool;

private _options = [];
{
    private _values = getArray ("CfgGroupCompositions" >> _unitPool >> _x);
    _options pushBack [_x, _values];
} forEach ["behaviour", "combatMode", "formation", "speed", "skill"];

private _options += getArray ("CfgGroupCompositions" >> _unitPool >> "options");

private _settings = [] call CBA_fnc_hashCreate;
private _type = getText ("CfgGroupCompositions" >> _unitPool >> "type");

_settings = [_settings, _marker, _type] call EFUNC(core,setBasicSettings);
[_grp, _settings, _options] call EFUNC(core,handleOptions);

[{CBA_missionTime > 0}, {
    params ["_group"];
    private _pfh =  _group getVariable [QEGVAR(core,pfh), -1];
    
    if (_pfh != -1) then {
        _pfh = [DEFUNC(core,mainPFH), 0, _group] call CBA_fnc_addPerFrameHandler;
    };
    _group setVariable [QEGVAR(core,pfh), _pfh, true];
}, _group] call CBA_fnc_waitUntilAndExecute;

_grp
