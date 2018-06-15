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

private _leaderPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "leaders");
private _unitPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "units");
private _side = getText (configFile >> "CfgGroupCompositions" >> _configEntry >> "side");

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;
private _units = [_units, 10] call EFUNC(core,shuffleArray);

if (count _leaderPool > 1) then {
    _leaderPool = [_leaderPool, 10] call EFUNC(core,suffleArray);
};

private _spawnUnits pushBack (_leaderPool # 0);

// Ignore leader
for "_i" from 1 to (_size - 1) do {
    _spawnUnits pushBack (selectRandom _units);
};

private _targetPos = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, typeOf (_leaderPool # 0)]] call EFUNC(waypoint,markerRandomPos);
[_group, [_spawnUnits], _targetPos] call FUNC(spawnGroup);

/*
{
    // Check if the maximum size of the group has been reached substracting the leader position
    if (_forEachIndex + 1 > (_size -1 )) exitWith {};
    private _unit = selectRandom _configEntry;

    private _position = _targetPos findEmptyPosition [0, 60, typeOf _unit];
    private _unit = _group createUnit [_unit, _position, [], 2, "FORM"];
    sleep _sleep;

} forEach _unitPool;
*/
