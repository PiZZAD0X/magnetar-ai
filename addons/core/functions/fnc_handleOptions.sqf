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

params ["_group", ["_options", []]];

{
    _x params ["_key", "_value"];

    private _getValue = {
        params ["_val"];
        if (isArray _value) then {
            _val = selectRandom _value;
        } else {
            _val = _value
        };
        _val
    };

    switch (toLower _key) do {
        case "behaviour": {_group setBehaviour ([_value] call _getValue)};
        case "combatmode": {_group setCombatMode ([_value] call _getValue)};
        case "formation": {_group setFormation ([_value] call _getValue)};
        case "speed": {_group setSpeedMode ([_value] call _getValue)};
        case "skill": {
            private _skillCategory = [];
            if ((toLower (_value # 0)) isEqualTo "general") then {
                _skillCategory = ["general"];
            } else {
                _skillCategory = ["aimingShake", "aimingSpeed", "endurance", "spotDistance", "spotTime", "courage", "reloadSpeed", "commanding"];
            };

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
            };
        };
        case "patrol": {
            _group setVariable [QGVAR(taskAssigned), "patrol", true];
        };
        case "defend": {
            _group setVariable [QGVAR(taskAssigned), "defend", true];
        };
        case "init": {
            _group call compile _value;
        };
    };
} forEach _options;
