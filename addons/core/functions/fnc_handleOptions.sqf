/*
 * Author: TheMagnetar
 * Handles assigning the additional options to the group.
 *
 * Arguments:
 * 0: Unit <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call mai_core_fnc_handleOptions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_settings", ["_options", []]];

{
    _x params ["_key", "_value"];

    private _getValue = {
        params ["_value"];

        private "_val";
        if (isArray _value) then {
            _val = selectRandom _value;
        } else {
            _val = _value
        };
        _val
    };
    systemChat format ["key %1 value %2", _key, _value];
    switch (toLower _key) do {
        case "behaviour": {
            [_settings, "behaviour", _value] call CBA_fnc_hashSet;
            _group setBehaviour ([_value] call _getValue);
        };
        case "combatmode": {
            [_settings, "combatMode", _value] call CBA_fnc_hashSet;
            _group setCombatMode ([_value] call _getValue);
        };
        case "formation": {
            [_settings, "formation", _value] call CBA_fnc_hashSet;
            _group setFormation ([_value] call _getValue);
        };
        case "speed": {
            [_settings, "speed", _value] call CBA_fnc_hashSet;
            _group setSpeedMode ([_value] call _getValue);
        };
        case "skill": {
            [_settings, "skill", _value] call CBA_fnc_hashSet;
            [_group, _value] call FUNC(setSkill);
        };
        case "patrol": { [_settings, "task", "patrol"] call CBA_fnc_hashSet; };
        case "defend": { [_settings, "task", "defend"] call CBA_fnc_hashSet; };
        case "init": { [_settings, "init", _value] call CBA_fnc_hashSet; _group call compile _value; };
        case "allowwater": { [_settings, "allowWater", _value] call CBA_fnc_hashSet; };
        case "allowland": { [_settings, "allowLand", _value] call CBA_fnc_hashSet; };
        case "forceroads": { [_settings, "forceRoads", _value] call CBA_fnc_hashSet; };
        case "randombehaviour": { [_settings, "randomBehaviour", _value] call CBA_fnc_hashSet; };
        case "waitAtWaypoint": { [_settings, "waitAtWaypoint", _value] call CBA_fnc_hashSet; };
        case "allowVehicles": { [_settings, "allowVehicles", _value] call CBA_fnc_hashSet };
        case "patrolBuildings": { [_settings, "patrolBuildings", _value] call CBA_fnc_hashSet; };
    };
} forEach _options;

_group setVariable [QGVAR(settings), _settings, true];
