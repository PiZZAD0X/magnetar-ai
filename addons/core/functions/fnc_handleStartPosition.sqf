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
 * [group1] call mai_spawn_fnc_populateMarker
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

if (_inRandomPosition || {!(_position isEqualTo [])} ) exitWith {
    private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
    private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
    private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

    // Select a unit
    private _unitInVehicle = (units _group) findIf {vehicle _x != _x};
    private _assignedVehicles = [];
    private _unit = objNull;

    if (_unitInVehicle != -1) then {
        _unit = vehicle ((units _group) # _unitInVehicle);
        // Get all vehicles
        {
            if (vehicle _x != _x) then {
                _assignedVehicles pushBackUnique (vehicle _x);
            };
        } forEach (units _group);
    } else {
        _unit = (units _group) # 0;
    };

    if (_position isEqualTo []) then {
        _position = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, typeOf _unit]] call EFUNC(waypoint,markerRandomPos);
    };

    private _leader = leader _group;
    if (vehicle _leader == _leader) then {
        _leader setPos _position;
    } else {
        (vehicle _leader) setPos _position;

        {
            _x setPos (_position findEmptyPosition [0, 60, typeOf _x]);
        } forEach (_assignedVehicles - [vehicle _leader]);
    };

    {
        if (vehicle _x == _x) then {
            _x setPos ((_position findEmptyPosition [0, 60, typeOf _x]) vectorAdd (formationPosition _x));
        }
    } forEach ((units _group) - [_leader]);

    _group setVariable [QGVAR(startPosition), nil];
};

if (_inRandomBuilding) exitWith {
    private _marker = [_settings, "marker"] call CBA_fnc_hashGet;
    private _positions = [_marker, [0, 50, (units _group # 0)]] call EFUNC(waypoint,markerRandomBuildingPos);

    {
        _x setPos (_positions # _forEachIndex);
    } forEach (units _group);
};

ERROR("No position assigned");
