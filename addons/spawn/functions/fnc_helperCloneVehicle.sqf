/*
 * Author: TheMagnetar
 * Helper function for cloning a group of units with vehicles.
 *
 * Arguments:
 * 0: Group to clone <OBJECT>
 * 1: Cloned group <OBJECT>
 * 2: Position <ARRAY>
 * 3: Sleep time between unit creation <NUMBER> (default: 0.05)
 *
 * Return Value:
 * None
 *
 * Example:
 * [gropu player1, group2, getPos player, 0.05] call mai_spawn_fnc_helperCloneVehicle
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_modelGroup", "_cloneGroup", "_position", "_sleep"];

private _units = units _modelGroup;
private _vehicleUnits = [];
{
    if (_x != vehicle _x) then {
        _vehicleUnits pushBackUnique (vehicle _x);
    }
} forEach _units;

{
    private _modelVehicle = _x;
    private _vehiclePos = _position findEmptyPosition [0, 50, typeOf _modelVehicle];
    private _vehicleUnit = createVehicle [typeOf _modelVehicle, _vehiclePos, [], 2, "FORM"];

    // Generate units
    {
        private _modelUnit = _x # 0;

        if (!isNull _modelUnit) then {
            private _type = typeOf _modelUnit;
            private _pos = _position findEmptyPosition [0, 50, _type];
            private _unit = _cloneGroup createUnit [typeOf _modelUnit, _position, [], 2, "NONE"];
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
                    _unit assignAsCargoIndex [_vehicleUnit, _x # 2];
                    _unit moveInCargo _vehicleUnit;
                };
            };

            if (leader _modelGroup == _modelUnit) then {
                _cloneGroup selectLeader _unit;
            };
        };

        sleep _sleep;
    } forEach (fullCrew [_modelVehicle, "", true]);
} forEach _vehicleUnits;
