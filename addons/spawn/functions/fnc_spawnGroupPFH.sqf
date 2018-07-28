/*
 * Author: TheMagnetar
 * Spawn PFH.
 *
 * Arguments:
 * 0: Parameters <ARRAY>
 * 1: PerFrameHandler identifier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], 2] call mai_spawn_fnc_spawnGroupPFH
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_param", "_handle"];

if (GVAR(spawnQueue) isEqualTo []) exitWith {
    [GVAR(spawnGroupPFH)] call CBA_fnc_removePerFrameHandler;
    GVAR(spawnGroupPFH) = -1;
};

private _toSpawn = GVAR(spawnQueue) deleteAt 0;
_toSpawn params [["_entity", [], ["", []]], "_marker", "_type", "_side", ["_size", 0], ["_position", []], ["_settings", []], ["_options", []]];

if (_entity isEqualType "") then {
    if (isClass (missionConfigFile >> "CfgGroupCompositions" >> _entity)) then {
        [_entity, _size, _marker, _position] call FUNC(spawnGroupFromConfig);
    } else {
        [_entity, 1, _marker, _position] call FUNC(spawnGroupFromTemplate);
    }
} else {
    [_entity, _marker, _type, _side, _position, _settings, _options] call FUNC(spawnGroup);
};
