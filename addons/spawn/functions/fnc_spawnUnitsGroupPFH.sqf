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

private _pos = _group getVariable [QEGVAR(core,startPosition), [0, 0, 0]];
private _position = [0, 0, 0];
if ((_pos # 0) isEqualType []) then {
    _position = _pos deleteAt 0;
} else {
    _position = _pos;
};
private _unitType = _unitsToSpawn deleteAt 0;

private _templateValues = _group getVariable [QGVAR(template), []];
private _useTemplate = !(_templateValues isEqualTo []);
private _applyTemplate = {
    params ["_unit", "_loadout", "_rank", "_skill"];

    _unit setUnitLoadout _loadout;
    _unit setRank _rank;
    _unit setSkill _skill;
};

if (_unitType isEqualType "") then {
    private _unitPos = _position findEmptyPosition [0, 60, _unitType];
    private _spawnedUnit = _group createUnit [_unitType, _unitPos, [], 2, "FORM"];

    if (isNull (_group getVariable [QEGVAR(core,leader), objNull])) then {
        _group selectLeader _spawnedUnit;
        _group setVariable [QEGVAR(core,leader), _spawnedUnit, true];
    };

    if (_useTemplate) then {
        _templateValues params ["_loadout", "_rank", "_skill"];
        [_spawnedUnit, _loadout deleteAt 0, _rank deleteAt 0, _skill deleteAt 0] call _applyTemplate;
    };
} else {
    _unitType params ["_vehicle", ["_crew", []], ["_cargo", []], ["_pilots",[]]];

    _templateValues params ["_loadout", "_rank", "_skill"];
    _loadout params ["_loadoutVeh", "_loadoutCrew", "_loadoutCargo", "_loadoutPilots"];
    _rank params ["_rankCrew", "_rankCargo", "_rankPilots"];
    _skill params ["_skillCrew", "_skillCargo", "_skillPilots"];

    private _unitPos = _position findEmptyPosition [0, 60, _vehicle];

    private _vehicleUnit = createVehicle [_vehicle, _unitPos, [], 20, "FORM"];
    private _vehicleRoles = fullCrew [_vehicleUnit, "", true];
    private _turrets = allTurrets [_vehicleUnit, false];
    private _hasCommander = false;
    private _hasGunner = false;

    {
        private _role = toLower (_x # 1);
        private _unit = objNull;
        private _nullPos = [0, 0, 0];
        switch (_role) do {
            case "driver": {
                if (_vehicle isKindOf "Air") then {
                    _unit = _group createUnit [_pilots # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                    _pilots deleteAt 0;

                    if (_useTemplate) then {
                        [_unit, _loadoutPilots deleteAt 0, _rankPilots deleteAt 0, _skillPilots deleteAt 0] call _applyTemplate;
                    };
                } else {
                    _unit = _group createUnit [_crew # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                    _crew deleteAt 0;

                    if (_useTemplate) then {
                        [_unit, _loadoutCrew deleteAt 0, _rankCrew deleteAt 0, _skillCrew deleteAt 0] call _applyTemplate;
                    };
                };
                _unit moveInDriver _vehicleUnit;
            };

            case "gunner": {
                if (_vehicle isKindOf "Air") then {
                    _unit = _group createUnit [_pilots # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                    _pilots deleteAt 0;

                    if (_useTemplate) then {
                        [_unit, _loadoutPilots deleteAt 0, _rankPilots deleteAt 0, _skillPilots deleteAt 0] call _applyTemplate;
                    };
                } else {
                    _unit = _group createUnit [_crew # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                    _crew deleteAt 0;

                    if (_useTemplate) then {
                        [_unit, _loadoutCrew deleteAt 0, _rankCrew deleteAt 0, _skillCrew deleteAt 0] call _applyTemplate;
                    };
                };
                _hasGunner = true;
                _unit moveInGunner _vehicleUnit;
            };

            case "turret": {
                if (_vehicle isKindOf "Air" && {getNumber ([_vehicle, _x # 3] call CBA_fnc_getTurret >> "isCopilot") == 1}) then {
                    private _unit = _group createUnit [_pilots # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                    _pilots deleteAt 0;

                    if (_useTemplate) then {
                        [_unit, _loadoutPilots deleteAt 0, _rankPilots deleteAt 0, _skillPilots deleteAt 0] call _applyTemplate;
                    };
                } else {
                    if (_x # 3 in _turrets) then {
                        private _unit = _group createUnit [_crew # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                        _crew deleteAt 0;

                        if (_useTemplate) then {
                            [_unit, _loadoutCrew deleteAt 0, _rankCrew deleteAt 0, _skillCrew deleteAt 0] call _applyTemplate;
                        };
                    } else {
                        private _unit = _group createUnit [_cargo # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                        _cargo deleteAt 0;

                        if (_useTemplate) then {
                            [_unit, _loadoutCargo deleteAt 0, _rankCargo deleteAt 0, _skillCargo deleteAt 0] call _applyTemplate;
                        };
                    };
                };
                _unit moveInTurret [_vehicleUnit, _x # 3];
            };

            case "commander": {
                private _unit = _group createUnit [_crew # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                _crew deleteAt 0;
                _hasCommander = true;
                _unit moveInCommander _vehicleUnit;

                if (_useTemplate) then {
                    [_unit, _loadoutCrew deleteAt 0, _rankCrew deleteAt 0, _skillCrew deleteAt 0] call _applyTemplate;
                };
            };

            case "cargo": {
                if !(_cargo isEqualTo []) then {
                    private _unit = _group createUnit [_cargo # 0, _nullPos, [], 0, "CAN_COLLIDE"];
                    _cargo deleteAt 0;
                    _unit assignAsCargoIndex [_vehicleUnit, _x # 2];
                    _unit moveInCargo _vehicleUnit;

                    if (_useTemplate) then {
                        [_unit, _loadoutCargo deleteAt 0, _rankCargo deleteAt 0, _skillCargo deleteAt 0] call _applyTemplate;
                    };
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

        _group setVariable [QEGVAR(core,leader), _leader, true];
    };
};
