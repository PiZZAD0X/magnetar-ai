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

params ["_group", ["_unassign", false], ["_doPerimeter", true], ["_forceAll", false]];

private _vehicle = vehicle (leader _group);
_group setVariable [QGVAR(assignedVehicle), _vehicle];
// Stop the vehicle
doStop (driver _vehicle);

private _units = [_vehicle, _forceAll] call FUNC(selectUnitsDisembark);
systemChat format ["Units %1", _units];
private _settings = _group getVariable [QEGVAR(core,settings), []];

private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

private _positionVehicle = getPos _vehicle;
private _dirIncrease = 360/(count _units);
private _dirOffset = 0;
{
    if (_unassign) then {
        unassignVehicle _x;
    };

    doGetOut _x;
    [_x] allowGetIn false;
    _x setVariable [QGVAR(markedForDisembark), true];

    private _tries = 0;
    // Calculate new position
    while {_tries < 50 && _doPerimeter} do {
        // Start by checking the back of the vehicle
        private _dir = (getDir _vehicle) + 180 + (_dirOffset + random 20 - 10);
        _dirOffset = _dirOffset + _dirIncrease;
        private _trialPos = _vehicle getPos [25 + random 10 -5, _dir];

        if (_allowWater && {surfaceIsWater _trialPos} || {_allowLand && {!surfaceIsWater _trialPos}}) then {
            private _checkedPos = [];
            _checkedPos = _trialPos findEmptyPosition [0, 5, typeOf _x];

            if (_checkedPos isEqualTo []) then {
                _tries = _tries + 1;
            } else {
                _x doMove _checkedPos;
                _tries = 50;
            };
        } else {
            _tries = _tries + 1;
        };
    };
} forEach _units;
