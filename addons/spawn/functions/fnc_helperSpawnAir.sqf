/*
 * Author: TheMagnetar
 * Selects random armored vehicles and their crew for spawning a group.
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
private _cargoPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "cargo");
private _pilotPool = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "pilot");

private _side = getText (configFile >> "CfgGroupCompositions" >> _configEntry >> "side");

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

{
    if (count _x > 1) then {
       _x = [_x, 10] call EFUNC(core,suffleArray);
    };
} forEach [_vehiclePool, _crewPool, _cargoLeaders, _cargoPool, _pilotPool];

private _spawnVehicles = [];

_size params ["_groupSize", "_cargoSize"];
private _fillAllCargo = false;
private _maxCargo = 3;
private _cargoSize = 0;

for "_i" from 1 to _groupSize do {
    private _vehicle = selectRandom _vehiclePool;
    private _roles = _vehicle call BIS_fnc_vehicleRoles;
    private _cargoUnits pushBack (selectRandom _cargoLeaders);
    private _crewUnits = [];
    private _pilots = [];

    {
        if (toLower (_x # 0) == "cargo" && {(_cargoSize < (_maxCargo - 1)) || _fillAllCargo}) then {
            _cargoUnits pushBack (selectRandom _cargoPool);
            _cargoSize = _cargoSize + 1;
        } else {
            if ((toLower (_x # 0) in ["driver", "gunner"]) || {toLower (_x # 0) == "turret" && {getNumber ([_vehicle, _x # 1] call CBA_fnc_getTurret >> "isCopilot") == 1}}) then {
                _pilots pushBack (selectRandom _pilotPool);
            } else {
                _crewUnits pushBack (selectRandom _crewPool);
            };
        };
    } forEach _roles;

    _spawnVehicles pushBack [_vehicle, _crewUnits, _cargoUnits, _pilots];
};

private _targetPos = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, typeOf (_spawnVehicles # 0) # 0]] call EFUNC(waypoint,markerRandomPos);
[_group, _spawnVehicles, _targetPos] call FUNC(spawnGroup);
