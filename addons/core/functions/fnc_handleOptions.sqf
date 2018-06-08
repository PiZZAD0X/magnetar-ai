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
            private _skillCategory = [];
            if ((toLower (_value # 0)) isEqualTo "general") then {
                _skillCategory = ["general"];
            } else {
                _skillCategory = ["aimingShake", "aimingSpeed", "endurance", "spotDistance", "spotTime", "courage", "reloadSpeed", "commanding"];
            };

            [_settings, "skill", _value] call CBA_fnc_hashSet;
            {
                private _unit = _x;
                {
                    private _val = 0;
                    if (isArray (_value # _forEachIndex)) then {
                        (_value # _forEachIndex) params ["_min", "_max"];

                        _val = _min + random [_max - _min];
                    } else {
                        _val = (_value # _forEachIndex);
                    };
                    _unit setSkill [_x, _val];
                } forEach _skillCategory;
            } forEach (units _group);
        };
        case "patrol": { [_settings, "task", "patrol"] call CBA_fnc_hashSet; };
        case "defend": { [_settings, "task", "defend"] call CBA_fnc_hashSet; };
        case "init": { _group call compile _value; };
        case "allowwater": { [_settings, "allowWater", _value] call CBA_fnc_hashSet; };
        case "forcerloads": { [_settings, "forceRoads", _value] call CBA_fnc_hashSet; };
        case "randombehaviour": { [_settings, "randomBehaviour", _value] call CBA_fnc_hashSet; };
    };
} forEach _options;

[_settings, "taskState", "init"] call CBA_fnc_hashSet;

_group setVariable [QGVAR(settings), _settings, true];
