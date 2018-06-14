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
 * [player] call mai_spawn_fnc_spawnInfantryGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_group", objNull], ["_units", []], "_position", "_type", "_side", ["_options", []], ["_sleep", 0.05]];

private _groupCreated = false;
private _settings = [];
if (isNull _group) then {
    _group = createGroup _side;
    _settings = [] call CBA_fnc_hashCreate;
    _settings = [_settings, _marker, _type] call EFUNC(core,setBasicSettings);

    // Init all group options
    [_grp, _settings, _options] call EFUNC(core,handleOptions);
    _groupCreated = true;
} else {
    _settings = _group getVariable [QEVGAR(core,settings), []];
    _type = [_settings, "type"] call CBA_fnc_hashGet;
};

_units params [["_infUnits"], ["_vehicles", []], ["_leader", objNull] ["_crew", []], ["_pilots", []]];

private _isInfantry = "infantry" isEqualTo (toLower _type);

{
    if (_isInfantry) then {
        private _unitPos = _position findEmptyPosition [0, 60, _x];
        private _unit = _group createUnit [_x, _unitPos, [], 2, "FORM"];
        sleep _sleep;
    } else {
        _x params ["_vehicle", ["_crew", []], ["_cargo", []], ["_pilots",[]]];

        private _unitPos = _position findEmptyPosition [0, 60, _vehicle];
        private _unit = _group createUnit [_vehicle, _unitPos, [], 2, "FORM"];
        {
            private _unit = _group createUnit [_x, _unitPos, [], 2, "NONE"];
        } forEach _pilots;

        {

        } forEach _crew;

        {
            
        } forEach _cargo;
    }

    
} forEach _units;

if (_isInfantry) then {
    (_units # 0) setLeader _group;
};

if (_groupCreated) then {
    // Apply basic options
    [_group, _settings] call EFUNC(core,applyOptions);
};

_grp
