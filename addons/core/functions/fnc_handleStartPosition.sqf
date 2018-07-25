/*
 * Author: TheMagnetar
 * Handles positioning a spawned group or editor placed groups with random start positions.
 *
 * Arguments:
 * 0: Group <OBJECT>
 * 1: Settings <HASH> (Default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * [group1] call mai_spawn_fnc_handleStartPosition
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", ["_settings", []]];

if (_settings isEqualTo []) then {
    _settings = _group getVariable [QGVAR(settings), []];
};

private _inRandomPosition = [_settings, "randomPosition"] call CBA_fnc_hashGet;
private _inRandomBuilding = [_settings, "spawnInBuilding"] call CBA_fnc_hashGet;
private _marker = [_settings, "marker"] call CBA_fnc_hashGet;

private _position = _group getVariable [QGVAR(startPosition), []];

private _units = units _group;
if (_units isEqualTo []) then {
    _units = _group getVariable [QEGVAR(spawn,unitsToSpawn), []];
};

if (_inRandomPosition || {!(_position isEqualTo [])} ) exitWith {
    private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
    private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
    private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

    // Select a unit
    private _unit = "";
    if ((_units # 0) isEqualTypeAny ["", []]) then {
        if ((_units # 0) isEqualType "") then {
            _unit = _units # 0;
        } else {
            _unit = _units # 0 # 0;
        };
    } else {
        private _unitInVehicle = _units findIf {vehicle _x != _x};
        if (_unitInVehicle != -1) then {
            _unit = typeOf (vehicle (_units # _unitInVehicle));
        } else {
            _unit = typeOf (_units # 0);
        };
    };

    if (_position isEqualTo []) then {
        _position = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, _unit]] call EFUNC(waypoint,markerRandomPos);
    };

    _group setVariable [QGVAR(startPosition), _position];
};

if (_inRandomBuilding) exitWith {
    private _marker = [_settings, "marker"] call CBA_fnc_hashGet;
    private _positions = [_marker, [0, 50, _units # 0]] call EFUNC(waypoint,markerRandomBuildingPos);
};

ERROR("No position assigned");
