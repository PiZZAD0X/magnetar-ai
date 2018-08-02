/*
 * Author: TheMagnetar
 * Spawns a group of units.
 *
 * Arguments:
 * 0: Unit array. First position is always the leader <ARRAY> (Default: [])
 * 1: Marker <STRING> (default: "")
 * 2: Unit type <STRING> (default: "")
 * 3: Unit side <STRING> (default: "")
 * 4: Position <ARRAY><OBJECT><LOCATION><GROUP> (default: [])
 * 5: Settings <HASH> (default: [])
 * 6: Group options <ARRAY> (default: [])
 *
 * Return Value:
 * Group <OBJECT>
 *
 * Example:
 * [units, "marker", "infantry", "west"] call mai_spawn_fnc_spawnGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [
    ["_units", [], [[]]],
    ["_marker", "", ["", []]],
    ["_type", "", [""]],
    ["_side", "", [""]],
    ["_position", [], [[], objNull, grpNull, locationNull], [2, 3]],
    ["_settings", [], [[]]],
    ["_options", [], [[]]]
];

if (!([_marker] call EFUNC(waypoint,checkMarkerInput))) exitWith {};

_position = _position call CBA_fnc_getPos;

private _group = objNull;
switch (toLower _side) do {
    case "civilian": {_group = createGroup civilian};
    case "east": {_group = createGroup east};
    case "resistance": {_group = createGroup resistance};
    case "west": {_group = createGroup west};
};

if (_settings isEqualTo []) then {
    _settings = [] call CBA_fnc_hashCreate;
    _settings = [_settings, _marker, _type] call EFUNC(core,setBasicSettings);
    [_settings, _options] call EFUNC(core,parseOptions);
    _group setVariable [QGVAR(settings), _settings, true];
};

if !(_position isEqualTo []) then {
    _group setVariable [QEGVAR(core,startPosition), _position];
};

_group setVariable [QEGVAR(core,settings), _settings];
_group setVariable [QGVAR(unitsToSpawn), _units];

private _template = [_settings, "template"] call CBA_fnc_hashGet;

if !(_template isEqualTo "") then {
    private _templateValues = [EGVAR(core,groupTemplates), _template] call CBA_fnc_hashGet;

    _templateValues params ["", "", "", "_loadout", "_rank", "_skill"];
    _group setVariable [QGVAR(template), [_loadout, _rank, _skill]];
};

[_group, _settings] call EFUNC(core,applyOptionsPreSpawn);

[DFUNC(spawnUnitsGroupPFH), 0.1, _group] call CBA_fnc_addPerFrameHandler;
