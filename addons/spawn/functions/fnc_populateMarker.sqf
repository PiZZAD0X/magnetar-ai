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
 * [player] call mai_spawn_fnc_populateMarker
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_markerInfo", "_groupsToSpawn"];

if (!isServer) exitWith {};

_markerInfo params ["_marker"];

if (!GVAR(debugEnabled) && {markerAlpha _marker != 0}) then {
    _marker setMarkerAlpha 0;
};

{
    private _numGroups = _x # 0;
    (_x # 1) params ["_configEntry", "_groupSize", ["_position", []]];

    [_configEntry, _groupSize, _marker, _position] call FUNC(randSpawnGroup);

} forEach _groupsToSpawn;
