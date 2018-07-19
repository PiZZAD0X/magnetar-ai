/*
 * Author: TheMagnetar
 * Helper routine for spawning a random group of infantry units.
 *
 * Arguments:
 * 0: Config entry <STRING>
 * 1: Settings <HASH>
 * 2: Side <STRING>
 * 3: Size <NUMBER>
 * 4: Marker <STRING>
 * 5: Sleep time between unit creation <NUMBER> (default: 0.05)
 * 6: Position <ARRAY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * ["usmcInfantry", [], "west", 5, "marker", 0.05] call mai_spawn_fnc_helperSpawnInfantry
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_configEntry", "_settings", "_side", "_size", "_marker", "_sleep", ["_targetPos", []]];

private _leaderPool = getArray (missionConfigFile >> "CfgGroupCompositions" >> _configEntry >> "leaders");
private _unitPool = getArray (missionConfigFile >> "CfgGroupCompositions" >> _configEntry >> "units");

private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

private _random = (getNumber (missionConfigFile >> "CfgGroupCompositions" >> _configEntry >> "random")) == 1;
private _spawnUnits = [];

if (_random) then {
    _unitPool = [_unitPool, 10] call EFUNC(core,shuffleArray);

    if (count _leaderPool > 1) then {
        _leaderPool = [_leaderPool, 10] call EFUNC(core,shuffleArray);
    };

    _spawnUnits pushBack (selectRandom _leaderPool);

    // Ignore leader
    for "_i" from 1 to (_size - 1) do {
        _spawnUnits pushBack (selectRandom _unitPool);
    };
} else {
    _spawnUnits append _leaderPool;
    _spawnUnits append _unitPool;
};

if (_targetPos isEqualTo []) then {
    _targetPos = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, _spawnUnits # 0]] call EFUNC(waypoint,markerRandomPos)
};

[_spawnUnits, _marker, [_settings, "type"] call CBA_fnc_hashGet, _side, _targetPos, _settings, [], _sleep] spawn FUNC(spawnGroup);
