/*
 * Author: TheMagnetar
 * Creates a group template.
 *
 * Arguments:
 * 0: Template name <STRING>
 * 1: Marker <STRING>
 * 2: Number of groups <NUMBER>
 * 3: Position <ARRAY> (Default: [])
 * 4: Additional options for the group <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["SpecOps", "marker", 2] call mai_spawn_fnc_spawnFromTemplate
 * ["SpecOps", "marker", 3, [], [["SpawnInBuildings", true]]] call mai_spawn_fnc_spawnGroupFromTemplate
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_templateName", "_marker", "_numGroups", ["_position", []], ["_overrideOptions", []]];

private _template = [EGVAR(core,groupTemplates), _templateName] call CBA_fnc_hashGet;
if !(_template isEqualType []) exitWith {
    ERROR_1("Undefined template name %1",_templateName);
};

_template params ["_side", "_settings", "_units"];

// Determine group size
private _num = 0;
if (_numGroups isEqualType []) then {
    _numGroups params ["_minSize", "_maxSize"];
    _num = _minSize + floor (random (_maxSize - _minSize));
} else {
    _num = _numGroups;
};

if !(_overrideOptions isEqualTo []) then {
    [_settings, _overrideOptions] call EFUNC(core,parseOptions);
};

private _inRandomPosition = [_settings, "randomPosition"] call CBA_fnc_hashGet;
private _inRandomBuilding = [_settings, "spawnInBuilding"] call CBA_fnc_hashGet;
if (!_inRandomPosition && {!_inRandomBuilding} && {_position isEqualTo []}) then {
    [_settings, "randomPosition", true] call CBA_fnc_hashSet;
};

for "_i" from 1 to _num do {
    private _toSpawn =+ [_units, _marker, [_settings, "type"] call CBA_fnc_hashGet, _side, 0, _position, _settings, []];
    GVAR(spawnQueue) pushBack _toSpawn;
};

if (GVAR(spawnGroupPFH) == -1) then {
    GVAR(spawnGroupPFH) = [DFUNC(spawnGroupPFH), 1, []] call CBA_fnc_addPerFrameHandler;
};
