/*
 * Author: TheMagnetar
 * Spawns a group of units.
 *
 * Arguments:
 * 0: Unit array. First position is always the leader <ARRAY> (Default: [])
 * 1: Marker <STRING>
 * 2: Unit type <STRING>
 * 3: Unit side <STRING>
 * 4: Position <ARRAY> (default: [])
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

params [["_units", []], "_marker", "_type", "_side", ["_position", []], ["_settings", []], ["_options", []]];

if (getMarkerColor _marker == "") exitWith {
    ERROR_1("marker %1 does not exist", _marker);
};

private _group = objNull;
switch (_side) do {
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
    private _templateValues = [QGVAR(groupTemplates), _template] call CBA_fnc_hashGet;

    _tempate params ["", "", "", "_loadout", "_rank", "_skill"]
    _group setVariable [QGVAR(template), _loadout, _rank, _skill];

};

[DFUNC(spawnUnitsGroupPFH), 0.1, _group] call CBA_fnc_addPerFrameHandler;
