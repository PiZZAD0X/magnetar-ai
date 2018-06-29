/*
 * Author: TheMagnetar
 * Selects random wheeled vehicles and their crew for spawning a group.
 *
 * Arguments:
 * 0: Group  <OBJECT> (Default: [])
 * 1: Configuration entry <STRING>
 * 2: Side <STRING>
 * 3: Marker <STRING>
 * 4: Sleep time between unit creation <NUMBER> (default: 0.05)
 *
 * Return Value:
 * Group <OBJECT>
 *
 * Example:
 * [player] call mai_spawn_fnc_helperSpawnInfantry
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_configEntry", "_settings", "_side", "_size", "_marker", "_sleep", ["_targetPos", []]];

private _vehiclePool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "vehicles");
private _crewPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "crew");
private _cargoLeaders = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "cargoLeaders");
private _cargoPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "cargo");
private _pilotPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "pilot");

private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

{
    if (count _x > 1) then {
       _x = [_x, 10] call EFUNC(core,shuffleArray);
    };
} forEach [_vehiclePool, _crewPool, _cargoLeaders, _cargoPool, _pilotPoo];

private _spawnVehicles = [];

_size params ["_groupSize", "_cargoSize"];

for "_i" from 1 to _groupSize do {
    private _vehicle = selectRandom _vehiclePool;
    private _roles = _vehicle call BIS_fnc_vehicleRoles;
    private _cargoUnits = [];
    _cargoUnits pushBack (selectRandom _cargoLeaders);
    private _crewUnits = [];
    private _numCargo = 0;

    {
        private _role = toLower (_x # 0);
        switch (_role) do {
            case "cargo": {
                if (_numCargo < (_cargoSize - 1)) then {
                    _cargoUnits pushBack (selectRandom _cargoPool);
                    _numCargo = _numCargo + 1;
                };
            };
            case "driver": {
                if (_vehicle isKindOf "Air") then {
                    _pilots pushBack (selectRandom _pilotPool);
                } else {
                    _crewUnits pushBack (selectRandom _crewPool);
                };
            };
            case "gunner": {
                if (_vehicle isKindOf "Air") then {
                    _pilots pushBack (selectRandom _pilotPool);
                } else {
                    _crewUnits pushBack (selectRandom _crewPool);
                };
            };
            case "commander": {
                _crewUnits pushBack (selectRandom _crewPool);
            };
            case "turret": {
                if (_vehicle isKindOf "Air" && {getNumber ([_vehicle, _x # 1] call CBA_fnc_getTurret >> "isCopilot") == 1}) then {
                    _pilots pushBack (selectRandom _pilotPool);
                } else {
                    _crewUnits pushBack (selectRandom _crewPool);
                };
            };
        };
    } forEach _roles;

    _spawnVehicles pushBack [_vehicle, _crewUnits, _cargoUnits];
};

if (_targetPos isEqualTo []) then {
    _targetPos = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, (_spawnVehicles # 0) # 0]] call EFUNC(waypoint,markerRandomPos);
};

[_spawnVehicles, _marker, [_settings, "type"] call CBA_fnc_hashGet, _side, _targetPos, _settings, [], _sleep] spawn FUNC(spawnGroup);
