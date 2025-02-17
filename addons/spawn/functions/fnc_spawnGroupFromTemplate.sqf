/*
 * Author: TheMagnetar
 * Creates a group template.
 *
 * Arguments:
 * 0: Template name <STRING> (default: "")
 * 1: Group size either in [min, max] format or a defined number <ARRAY><NUMBER>
 * 2: Marker <STRING> (default: "")
 * 3: Position <ARRAY><OBJECT><LOCATION><GROUP> (default: [])
 * 4: Additional options for the group <ARRAY> (default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * ["SpecOps", "marker", 2] call mai_spawn_fnc_spawnGroupFromTemplate
 * ["SpecOps", "marker", 3, [], [["SpawnInBuildings", true]]] call mai_spawn_fnc_spawnGroupFromTemplate
 *
 * Public: Yes
 */
#include "script_component.hpp"
EXEC_CHECK(SERVERHC);

params [
    ["_templateName", "", [""]],
    ["_numGroups", 0, [[], 0], [2]],
    ["_marker", "", ["", []]],
    ["_position", [], [[], objNull, grpNull, locationNull], [0, 2, 3]],
    ["_overrideOptions", [], [[]]]
];

if (!([_marker] call EFUNC(waypoint,checkMarkerInput))) exitWith {};

private _template = [EGVAR(core,groupTemplates), _templateName] call CBA_fnc_hashGet;
if !(_template isEqualType []) exitWith {
    ERROR_1("Undefined template name %1",_templateName);
};

_template params ["_side", "_settings", "_units"];
_position = _position call CBA_fnc_getPos;

// Determine group size
private _num = [_numGroups] call EFUNC(core,getRandomMinMax);

if !(_overrideOptions isEqualTo []) then {
    [_settings, _overrideOptions] call EFUNC(core,parseOptions);
};

private _inRandomPosition = [_settings, "randomPosition"] call CBA_fnc_hashGet;
private _inRandomBuilding = [_settings, "spawnInBuilding"] call CBA_fnc_hashGet;
if (!_inRandomPosition && {!_inRandomBuilding} && {_position isEqualTo []}) then {
    [_settings, "randomPosition", true] call CBA_fnc_hashSet;
};

for "_i" from 1 to _num do {
    private _toSpawn =+ [_units, _marker, [_settings, "type"] call CBA_fnc_hashGet, _side, _position, _settings, []];
    GVAR(spawnQueue) pushBack _toSpawn;
};

if (GVAR(spawnGroupPFH) == -1) then {
    GVAR(spawnGroupPFH) = [DFUNC(spawnGroupPFH), 1, []] call CBA_fnc_addPerFrameHandler;
};
