/*
 * Author: TheMagnetar
 * Handles assigning the additional options to the group.
 *
 * Arguments:
 * 0: Settings <HASH>
 * 1: Additional options <ARRAY> (default: [])
 *
 * Return Value:
 * Settings expanded with the parsed options <HASH>
 *
 * Example:
 * [player, [["task", "patrol"]]] call mai_core_fnc_parseOptions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_settings", ["_options", []]];

{
    _x params ["_key", "_value"];

    if (_value isEqualType "" && {_value == "true" || _value == "false"}) then {
        if (_value == "true") then {
            _value = true;
        } else {
            _value = false;
        };
    };

    switch (toLower _key) do {
        case "behaviour": { [_settings, "behaviour", _value] call CBA_fnc_hashSet; };
        case "combatmode": { [_settings, "combatMode", _value] call CBA_fnc_hashSet; };
        case "formation": { [_settings, "formation", _value] call CBA_fnc_hashSet; };
        case "speed": { [_settings, "speed", _value] call CBA_fnc_hashSet; };
        case "skill": { [_settings, "skill", _value] call CBA_fnc_hashSet; };
        case "skillLeader": { [_settings, "skillLeader", _value] call CBA_fnc_hashSet; };
        case "task": { [_settings, "task", format [QEGVAR(tasks,%1),_value]] call CBA_fnc_hashSet; };
        case "init": { [_settings, "init", _value] call CBA_fnc_hashSet; };
        case "allowwater": { [_settings, "allowWater", _value] call CBA_fnc_hashSet; };
        case "allowland": { [_settings, "allowLand", _value] call CBA_fnc_hashSet; };
        case "forceroads": { [_settings, "forceRoads", _value] call CBA_fnc_hashSet; };
        case "randombehaviour": { [_settings, "randomBehaviour", _value] call CBA_fnc_hashSet; };
        case "waitatwaypoint": { [_settings, "waitAtWaypoint", _value] call CBA_fnc_hashSet; };
        case "allowvehicles": { [_settings, "allowVehicles", _value] call CBA_fnc_hashSet };
        case "patrolbuildings": { [_settings, "patrolBuildings", _value] call CBA_fnc_hashSet; };
    };
} forEach _options;

_settings
