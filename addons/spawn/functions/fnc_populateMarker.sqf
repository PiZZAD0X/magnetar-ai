/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Marker information <ARRAY>
 *  0: Marker <STRING>
 * 1: Groups to Spawn <ARRAY>
 *  0: Group count either in [min, max] format or a defined number <ARRAY><NUMBER> (default: 0)
 *  1: Config/template entry <STRING> (default: "")
 *  2: Group size either in [min, max] format or a defined number <ARRAY><NUMBER> (default: 0)
 *  3: Position <ARRAY><OBJECT><LOCATION><GROUP> (default: [])
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

params [
    ["_markerInfo", [], [[]], [1]],
    ["_groupsToSpawn", [], [[]]]
];

_markerInfo params [["_marker", "", [""]]];

if (getMarkerColor _marker == "") exitWith {
    ERROR_1("marker %1 does not exist", _marker);
};

if (!GVAR(debugEnabled) && {markerAlpha _marker != 0}) then {
    _marker setMarkerAlpha 0;
};

{
    _x params [
        ["_groupCount", 0, [[], 0], [1, 2]],
        ["_entry", "", [""]],
        ["_groupSize", 0, [[], 0], [2]],
        ["_position", [], [[], objNull, grpNull, locationNull], [2]]
    ];

    // Determine group count
    private _num = [_groupCount] call EFUNC(core,getRandomMinMax);

    for "_i" from 1 to _num do {
        GVAR(spawnQueue) pushBack [_entry, _marker, "", "", _groupSize, _position];
    };
} forEach _groupsToSpawn;

if (GVAR(spawnGroupPFH) == -1) then {
    GVAR(spawnGroupPFH) = [DFUNC(spawnGroupPFH), 1, []] call CBA_fnc_addPerFrameHandler;
};
