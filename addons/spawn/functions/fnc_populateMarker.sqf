/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Marker information <ARRAY>
 *  0: Marker <STRING>
 * 1: Groups to Spawn <ARRAY>
 *  0: Group count <NUMBER>
 *  1: Config entry <STRING>
 *  2: Group size either in [min, max] format or a defined number <ARRAY><NUMBER>
 *  3: Position <ARRAY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * [["marker"], [[3, "infantryUSMC", [2, 5]], [2, "infantryUSMC", 4]]] call mai_spawn_fnc_populateMarker
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_markerInfo", "_groupsToSpawn"];

_markerInfo params ["_marker"];

if (getMarkerColor _marker == "") exitWith {
    ERROR_1("marker %1 does not exist", _marker);
};

if (!GVAR(debugEnabled) && {markerAlpha _marker != 0}) then {
    _marker setMarkerAlpha 0;
};

{
    _x params ["_groupCount", "_configEntry", "_groupSize", ["_position", []]];
    for "_i" from 1 to _groupCount do {
        QGVAR(spawnQueue) pushBack [_configEntry, _marker, "", "", _groupSize, _position];
    };
} forEach _groupsToSpawn;

if (GVAR(spawnGroupPFH) == -1) then {
    GVAR(spawnGroupPFH) = [DFUNC(spawnGroupPFH), 1, []] call CBA_fnc_addPerFrameHandler;
};
