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

params ["_group", "_handle"];

private _unitsToSpawn = _group getVariable [QGVAR(unitsToSpawn), []];

if (_unitsToSpawn isEqualTo []) exitWith {
    [_handle] call CBA_fnc_removePerFrameHandler;
    _group setVariable [QGVAR(position), nil];

    private _settings = _group getVariable [QEGVAR(core,settings), []];
    [_group, _settings] call EFUNC(core,applyOptions);

    _group setVariable [QEGVAR(core,settings), _settings, true];
    _group setVariable [QEGVAR(core,enabled), true, true];

    // Register the group
    private _marker = [_settings, "marker"] call CBA_fnc_hashGet;
    [QGVAR(registerGroup), [_group, _marker]] call CBA_fnc_localEvent;
};

private _unitPos = [0, 0, 0];
private _unitType = _unitsToSpawn deleteAt 0;

if (_unitType isEqualType "") then {
    private _spawnedUnit = _group createUnit [_unitType, _unitPos, [], 0, "CAN_COLLIDE"];
    if (isNull (_group getVariable [QEGVAR(core,leader), objNull])) then {
        _group selectLeader _spawnedUnit;
        _group setVariable [QEGVAR(core,leader), _spawnedUnit];
    };
} else {
    _unitType params ["_vehicle", ["_crew", []], ["_cargo", []], ["_pilots",[]]];

    private _vehicleUnit = _vehicle createVehicle _unitPos;
    private _vehicleRoles = fullCrew [_vehicleUnit, "", true];
    private _turrets = allTurrets [_vehicleUnit, false];
    private _hasCommander = false;
    private _hasGunner = false;

    {
        private _role = toLower (_x # 1);
        private _unit = objNull;
        switch (_role) do {
            case "driver": {
                if (_vehicle isKindOf "Air") then {
                    _unit = _group createUnit [_pilots # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                    _pilots deleteAt 0;
                } else {
                    _unit = _group createUnit [_crew # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                    _crew deleteAt 0;
                };
                _unit moveInDriver _vehicleUnit;
            };

            case "gunner": {
                if (_vehicle isKindOf "Air") then {
                    _unit = _group createUnit [_pilots # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                    _pilots deleteAt 0;
                } else {
                    _unit = _group createUnit [_crew # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                    _crew deleteAt 0;
                };
                _hasGunner = true;
                _unit moveInGunner _vehicleUnit;
            };

            case "turret": {
                if (_vehicle isKindOf "Air" && {getNumber ([_vehicle, _x # 3] call CBA_fnc_getTurret >> "isCopilot") == 1}) then {
                    private _unit = _group createUnit [_pilots # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                    _pilots deleteAt 0;
                } else {
                    if (_x # 3 in _turrets) then {
                        private _unit = _group createUnit [_crew # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                        _crew deleteAt 0;
                    } else {
                        private _unit = _group createUnit [_cargo # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                        _cargo deleteAt 0;
                    };
                };
                _unit moveInTurret [_vehicleUnit, _x # 3];
            };

            case "commander": {
                private _unit = _group createUnit [_crew # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                _crew deleteAt 0;
                _hasCommander = true;
                _unit moveInCommander _vehicleUnit;
            };

            case "cargo": {
                if !(_cargo isEqualTo []) then {
                    private _unit = _group createUnit [_cargo # 0, _unitPos, [], 0, "CAN_COLLIDE"];
                    _cargo deleteAt 0;
                    _unit assignAsCargoIndex [_vehicleUnit, _x # 2];
                    _unit moveInCargo _vehicleUnit;
                };
            };
        };
    } forEach _vehicleRoles;

    if (isNull (_group getVariable [QEGVAR(core,leader), objNull])) then {
        private _leader = objNull;

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

        _group setVariable [QEGVAR(core,leader), _leader];
    };
};
