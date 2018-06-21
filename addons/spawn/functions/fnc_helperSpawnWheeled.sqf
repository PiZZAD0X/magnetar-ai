/*
 * Author: TheMagnetar
 * Selects random infantry units for spawning a group.
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

params ["_group", "_configEntry", "_size", "_marker", "_sleep"];

private _vehiclePool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "vehicles");
private _crewPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "crew");
private _cargoLeaders = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "cargoLeaders");
private _cargo = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "cargo");

private _side = getText (configFile >> "CfgGroupCompositions" >> _configEntry >> "side");

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

{
    if (count _x > 1) then {
       _x = [_x, 10] call EFUNC(core,suffleArray);
    };
} forEach [_vehiclePool, _crewPool, _cargoLeaders, _cargo];

private _spawnVehicles = [];
private _spawnCrew = [];
private _spawnCargo = [];

for "_i" from 1 to _size do {
    _spawnVehicles pushBack (selectRandom _units);
};
