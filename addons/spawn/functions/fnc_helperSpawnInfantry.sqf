/*
 * Author: TheMagnetar
 * Selects random infantry units for spawning a group
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
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_configEntry", "_size", "_marker", "_sleep"];

private _leaderPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "leaders");
private _unitPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "units");

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

_unitPool = [_unitPool, 10] call EFUNC(core,shuffleArray);

if (count _leaderPool > 1) then {
    _leaderPool = [_leaderPool, 10] call EFUNC(core,suffleArray);
};

private _spawnUnits = [];
_spawnUnits pushBack (selectRandom _leaderPool);

// Ignore leader
for "_i" from 1 to (_size - 1) do {
    _spawnUnits pushBack (selectRandom _unitPool);
};

private _targetPos = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, _spawnUnits # 0]] call EFUNC(waypoint,markerRandomPos);
[_group, _spawnUnits, _targetPos] call FUNC(spawnGroup);

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
