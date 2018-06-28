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

params ["_configEntry", "_settings", "_side", "_size", "_marker", "_sleep", ["_targetPos", []]];

private _leaderPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "leaders");
private _unitPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "units");

private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

_unitPool = [_unitPool, 10] call EFUNC(core,shuffleArray);

if (count _leaderPool > 1) then {
    _leaderPool = [_leaderPool, 10] call EFUNC(core,shuffleArray);
};

private _spawnUnits = [];
_spawnUnits pushBack (selectRandom _leaderPool);

// Ignore leader
for "_i" from 1 to (_size - 1) do {
    _spawnUnits pushBack (selectRandom _unitPool);
};

if (_targetPos isEqualTo []) then {
    _targetPos = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, typeOf (_spawnVehicles # 0) # 0]] call EFUNC(waypoint,markerRandomPos);
};

[_spawnUnits, _marker, [_settings, "type"] call CBA_fnc_hashGet, _side, _targetPos, _settings, [], _sleep] spawn FUNC(spawnGroup);
