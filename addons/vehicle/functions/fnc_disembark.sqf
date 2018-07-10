/*
 * Author: TheMagnetar
 * Disembark units from a vehicle.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Unassign vehicle <BOOL> (default: true)
 * 2: Do perimeter <BOOL> (default: true)
 * 3: Force disembark all units <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_vehicle_fnc_disembark
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", ["_unassign", true], ["_doPerimeter", true], ["_forceAll", false]];

systemChat format ["Arguments %1", _this];

private _vehicle = vehicle (leader _group);
_group setVariable [QGVAR(assignedVehicle), _vehicle];
systemChat format ["disembark"];

private _units = [_vehicle, _forceAll] call FUNC(selectUnitsDisembark);

// put leader at the first position
if ((leader _group) in _units) then {
    _units deleteAt (_units find (leaderGroup));
    reverse _units;
};
private _settings = _group getVariable [QEGVAR(core,settings), []];

private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;

private _dirIncrease = 360/(count _units);
systemChat format ["dirIncrease %1", _dirIncrease];
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

        private _trialPos = _vehicle getPos [20 + random 10 -5, _dir];

        if ((_allowWater && {surfaceIsWater _trialPos}) || {_allowLand && {!surfaceIsWater _trialPos}}) then {
            private _checkedPos = [];
            _checkedPos = _trialPos findEmptyPosition [0, 5, typeOf _x];

            if (_checkedPos isEqualTo []) then {
                _tries = _tries + 1;
            } else {
                _x setVariable [QGVAR(checkedPos), _checkedPos];
                if (EGVAR(core,debugEnabled)) then {
                    private _markerName = format ["marker_%1", CBA_missionTime + random 1];
                    private _marker = createMarker [_markerName, _checkedPos];
                    _markerName setMarkerShape "icon";
                    _markerName setMarkerType "hd_dot";
                    _markerName setMarkerColor "colorGreen";
                };
                _tries = 50;
            };
        } else {
            _tries = _tries + 1;
        };
    };
} forEach _units;
