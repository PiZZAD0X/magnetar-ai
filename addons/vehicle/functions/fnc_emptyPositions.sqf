/*
 * Author: TheMagnetar
 * Disembark units from a vehicle.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Distance <NUMBER> (default )
 *
 * Return Value:
 * Nearest vehicles suitable for the group
 *
 * Example:
 * [leader group player] call mai_vehicle_fnc_getNearVehicles
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _emptyPositions = [];

{
    if (isNull (_x # 0)) then {
        private _role = toLower (_x # 1);
        if (_role in ["cargo", "turret"]) then {
            if (_role isEqualTo "cargo") then {
                _emptyPositions pushBack ["cargo", _x # 2];
            } else {
                _emptyPositions pushBack ["turret", _x # 3];
            };
        } else {
            _emptyPositions pushBack _role;
        };
    };
} forEach (fullCrew [_vehicle, "", true]);

_emptyPositions
