/*
 * Author: TheMagnetar
 * Embark units to a vehicle.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Distance <NUMBER> (default )
 *
 * Return Value:
 * Nearest vehicles suitable for the group
 *
 * Example:
 * [vehicle player, [player]] call mai_vehicle_fnc_getInVehicle
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_units"];

private _emptyPositions = [_vehicle] call FUNC(emptyPositions);

private _leader = leader (_unit # 0);

if (((vehicle _leader) isEqualTo _leader) && {"commander" in _emptyPositions}) then {
    _leader assignAsCommander _vehicle;
    _emptyPositions deleteAt (_emptyPositions find "commander");
};

// Prioritise driver, gunner and commander seats
{
    private _assigned = false;
    if ("driver" in _emptyPositions) then {
        _x assignAsDriver _vehicle;
        _emptyPositions deleteAt (_emptyPositions find "driver");
        _assigned = true;
    };

    if ("gunner" in _emptyPositions && {!_assigned}) then {
        _x assignAsGunner _vehicle;
        _emptyPositions deleteAt (_emptyPositions find "gunner");
        _assigned = true;
    };

    if ("commander" in _emptyPositions && {!_assigned}) then {
        _x assignAsCommander _vehicle;
        _emptyPositions deleteAt (_emptyPositions find "commander");
        _assigned = true;
    };

    {
        if (["turret", _x] in _emptyPositions && {!_assigned}) exitWith {
            _x assignAsTurret [_vehicle, _x];
            _assigned = true;
        };
    } forEach (allTurrets [_vehicle, false]);

    // After filling in crew positions, try to fill in cargo ones
    {
        if (_x # 0 isEqualTo "turret" && {!_assigned}) exitWith {
            _x assignAsTurret [_vehicle, _x # 1];
        };

        if (_x # 0 isEqualTo "cargo" && {!_assigned}) exitWith {
            _x assignAsCargoIndex [_vehicle, _x # 1];
        };
    } forEach _emptyPositions;
} forEach _units;

_units orderGetIn _vehicle;
