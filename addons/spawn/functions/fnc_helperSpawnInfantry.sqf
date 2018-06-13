/*
 * Author: TheMagnetar
 * Spawns randomly a group of units from a unit pool
 *
 * Arguments:
 * 0: Group  <OBJECT> (Default: [])
 * 1: Configuration entry <STRING>
 * 2: Side <STRING>
 * 3: Marker <STRING>
 * 4: Sleep time between unit creation <NUMBER> (default: 0.05)
 *
 * Return Value:
 * Group <OBJECT>
 *
 * Example:
 * [player] call mai_spawn_fnc_helperSpawnInfantry
 *
 * Public: Yes
 */

params ["_group", "_configEntry", "_size", "_marker", "_sleep"];

private _leaderPool = getArray ("CfgGroupCompositions" >> _configEntry >> "leaders");
private _unitPool = getArray ("CfgGroupCompositions" >> _configEntry >> "units");
private _side = getText ("CfgGroupCompositions" >> _configEntry >> "side");

private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

private _targetPos = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, typeOf _leaderUnit]] call EFUNC(waypoint,markerRandomPos);

private _leaderUnit = selectRandon _leaderPool;
private _leader = _grp createUnit [, _position, [], 2, "FORM"];
_group setLeader _leader;

{
    // Check if the maximum size of the group has been reached substracting the leader position
    if (_forEachIndex + 1 > (_size -1 )) exitWith {};
    private _unit = selectRandom _configEntry;

    private _position = _targetPos findEmptyPosition [0, 60, typeOf _unit];
    private _unit = _group createUnit [_unit, _position, [], 2, "FORM"];
    sleep _sleep;

} forEach _unitPool;
