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

params [["_group", objNull], ["_units", []], "_position", "_type", "_marker", "_side", ["_options", []], ["_sleep", 0.05]];

private _groupCreated = false;
private _settings = [];
if (isNull _group) then {
    _group = createGroup _side;
    _settings = [] call CBA_fnc_hashCreate;
    _settings = [_settings, _marker, _type] call EFUNC(core,setBasicSettings);

    // Init all group options
    [_group, _settings, _options] call EFUNC(core,handleOptions);
    _groupCreated = true;
} else {
    _settings = _group getVariable [QEGVAR(core,settings), []];
    _type = [_settings, "type"] call CBA_fnc_hashGet;
};

private _isInfantry = "infantry" isEqualTo (toLower _type);
private _leader = objNull;
{
    if (_isInfantry) then {
        private _unitPos = _position findEmptyPosition [0, 60, _x];
        private _unit = _group createUnit [_x, _unitPos, [], 2, "FORM"];
        if (!isNull _leader) then {
            _leader = _unit;
        };
        sleep _sleep;
    } else {
        _x params ["_vehicle", ["_crew", []], ["_cargo", []], ["_pilots",[]]];

        private _unitPos = _position findEmptyPosition [0, 60, _vehicle];
        private _vehicleUnit = _group createUnit [_vehicle, _unitPos, [], 2, "FORM"];
        private _vehicleRoles = fullCrew [_vehicleUnit, "", true];
        private _hasCommander = false;
        private _hasGunner = false;
        {
            private _role = toLower (_x # 1);
            private _unit = objNull;
            switch (_role) do {
                case "driver": {
                    if (_vehicle isKindOf "Air") then {
                        _unit = _group createUnit [_pilots # 0, _unitPos, [], 2, "FORM"];
                        _pilots deleteAt 0;
                    } else {
                        _unit = _group createUnit [_crew # 0, _unitPos, [], 2, "FORM"];
                        _crew deleteAt 0;
                    };
                    _unit moveInDriver _vehicleUnit;
                };
                case "gunner": {
                    if (_vehicle isKindOf "Air") then {
                        _unit = _group createUnit [_pilots # 0, _unitPos, [], 2, "FORM"];
                        _pilots deleteAt 0;
                    } else {
                        _unit = _group createUnit [_crew # 0, _unitPos, [], 2, "FORM"];
                        _crew deleteAt 0;
                    };
                    _hasGunner = true;
                    _unit moveInGunner _vehicleUnit;
                };
                case "turret": {
                    if (_vehicle isKindOf "Air" && {getNumber ([_vehicle, _x # 3] call CBA_fnc_getTurret >> "isCopilot") == 1}) then {
                        private _unit = _group createUnit [_pilots # 0, _unitPos, [], 2, "FORM"];
                        _pilots deleteAt 0;
                    } else {
                        private _unit = _group createUnit [_crew # 0, _unitPos, [], 2, "FORM"];
                        _crew deleteAt 0;
                    };
                    _unit moveInTurret [_vehicleUnit, _x # 3];
                };
                case "commander": {
                    private _unit = _group createUnit [_crew # 0, _unitPos, [], 2, "FORM"];
                    _crew deleteAt 0;
                    _hasCommander = true;
                    _unit moveInCommander _vehicleUnit;
                };
                case "cargo": {
                    private _unit = _group createUnit [_cargo # 0, _unitPos, [], 2, "FORM"];
                    _cargo deleteAt 0;
                    _unit assignAsCargoIndex [_vehicleUnit, (_x # 2) # 0];
                    _unit moveInCargo _vehicleUnit;
                };
            };
        } forEach _vehicleRoles;
        if (isNull _leader) then {
            if (_hasCommander) then {
                _leader = commander _vehicleUnit;
            } else {
                if (_vehicleUnit isKindOf "Air") then {
                    _leader = driver _vehicleUnit;
                } else {
                    if (_hasGunner) then {
                        _leader = gunner _vehicleUnit;
                    } else {
                        _leader = driver _vehicleUnit
                    };
                };
            };
        };
    };
} forEach _units;

_leader setLeader _group;

if (_groupCreated) then {
    // Apply basic options
    [_group, _settings] call EFUNC(core,applyOptions);
};

_group
