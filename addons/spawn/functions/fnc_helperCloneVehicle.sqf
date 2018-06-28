/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Group to clone <OBJECT>
 * 1: Sleep time between unit creation <NUMBER> (default: 0.05)
 *
 * Return Value:
 * Group <OBJECT>
 *
 * Example:
 * [player] call mai_spawn_fnc_cloneGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_modelGroup", "_cloneGroup", "_position", "_sleep"];

private _units = units _modelGroup;
private _vehicleUnits = [];
{
    if !(_x isKindOf "CAManBase") then {
        _vehicleUnits pushBack _x;
    }
} forEach _units;

{
    private _modelVehicle = _x;
    private _vehiclePos = _position findEmptyPosition [0, 50, typeOf _modelVehicle];
    private _vehicleUnit = _group createUnit [_modelVehicle, _vehiclePos, [], 2, "FORM"];

    // Generate units
    {
        private _modelUnit = _x # 0;

        if (!isNull _unit) then {
            private _type = typeOf _unit;
            private _pos = _position findEmptyPosition [0, 50, _type];
            private _unit = _group createUnit [_modelUnit, _pos, [], 2, "NONE"];
            _unit setSkill (skill _modelUnit);

            private _role = _x # 1;
            switch (_role) do {
                case "driver": {
                    _unit moveInDriver _vehicleUnit;
                };
                case "gunner": {
                    _unit moveInGunner _vehicleUnit;
                };
                case "turret": {
                    _unit moveInTurret [_vehicleUnit, _x # 3];
                };
                case "commander": {
                    _unit moveInCommander _vehicleUnit;
                };
                case "cargo": {
                    _unit assignAsCargoIndex [_vehicleUnit, (_x # 2) # 0];
                    _unit moveInCargo _vehicleUnit;
                };
            };
        };
        private _type = typeOf (_x # 0);
        
        private _unit = _group createUnit [_x, _pos, [], 2, "NONE"];
        _unit setSkill (skill _x);

        if (leader _modelGroup == _x) then {
            _group setLeader _unit;
        };

        sleep _sleep;
    } forEach (fullCrew [_modelVehicle, "", true]);
} forEach _vehicleUnits;
