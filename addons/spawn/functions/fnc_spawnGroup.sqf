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

params [["_units", []], "_marker", "_type", "_side", ["_position", []], ["_settings", []], ["_options", []], ["_sleep", 0.05]];

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

private _isInfantry = "infantry" isEqualTo (toLower _type);
private _leader = objNull;
{
    if (_isInfantry) then {
        if (_position isEqualTo []) then {
            private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
            private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
            private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;
            _position = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, _units # 0]] call EFUNC(waypoint,markerRandomPos);
        };
        private _unitPos = _position findEmptyPosition [0, 60, _x];
        private _unit = _group createUnit [_x, _unitPos, [], 2, "FORM"];
        if (!isNull _leader) then {
            _leader = _unit;
        };
        sleep _sleep;
    } else {
        _x params ["_vehicle", ["_crew", []], ["_cargo", []], ["_pilots",[]]];

        if (_position isEqualTo []) then {
            private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
            private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
            private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;
            _position = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, _vehicle]] call EFUNC(waypoint,markerRandomPos);
        };
        private _unitPos = _position findEmptyPosition [0, 60, _vehicle];
        private _vehicleUnit = createVehicle [_vehicle, _unitPos, [], 2, "FORM"];
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
                        if (_x # 3 in _turrets) then {
                            private _unit = _group createUnit [_crew # 0, _unitPos, [], 2, "FORM"];
                            _crew deleteAt 0;
                        } else {
                            private _unit = _group createUnit [_cargo # 0, _unitPos, [], 2, "FORM"];
                            _cargo deleteAt 0;
                        };
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
                    if !(_cargo isEqualTo []) then {
                        private _unit = _group createUnit [_cargo # 0, _unitPos, [], 2, "FORM"];
                        _cargo deleteAt 0;
                        _unit assignAsCargoIndex [_vehicleUnit, _x # 2];
                        _unit moveInCargo _vehicleUnit;
                    };
                };
            };

            sleep _sleep;
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

[_group, _settings] call EFUNC(core,applyOptions);
_group setVariable [QEGVAR(core,settings), _settings];
_group setVariable [QEGVAR(core,enabled), true];

// Register the group
[QGVAR(registerGroup), [_group, _marker]] call CBA_fnc_serverEvent;

_group selectLeader _leader;

_group
