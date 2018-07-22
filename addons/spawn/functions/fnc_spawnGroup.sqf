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
 * 7: Sleep time between units <NUMBER> (default: 0.05)
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

params [["_units", []], "_marker", "_type", "_side", ["_position", []], ["_settings", []], ["_options", []], ["_sleep", 0.05]];

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
} else {
    _type = [_settings, "type"] call CBA_fnc_hashGet;
};

if !(_position isEqualTo []) then {
    _group setVariable [QEGVAR(core,startPosition), _position];
};
_group setVariable [QEGVAR(core,settings), _settings];
_group setVariable [QGVAR(unitsToSpawn), _units];
[DFUNC(spawnUnitsGroupPFH), 0.1, _group] call CBA_fnc_addPerFrameHandler;
