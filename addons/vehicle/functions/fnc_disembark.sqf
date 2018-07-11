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

private _vehicle = vehicle (leader _group);
_group setVariable [QGVAR(assignedVehicle), _vehicle];

private _units = [_vehicle, _forceAll] call FUNC(selectUnitsDisembark);

private _leader = leader _group;
// put leader at the first position. TODO: check if necessary
if (_leader in _units) then {
    _units deleteAt (_units find _leader);
    _units pushBack _leader;
    reverse _units;
};
private _settings = _group getVariable [QEGVAR(core,settings), []];

private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;

private _count = count _units;
switch (true) do {
    case _count == 1: {_dirIncrease = 5; _dirOffset = 270;};   // Provide small variation in order to iterate in case no positions are found.
    case _count == 2: {_dirIncrease = 120; _dirOffset = 210;}; // Units form a perimeter at the back of the vehicle with an angle of 120 degrees.
    case (_count >= 3 && _count <= 5): {_dirIncrease = 180/_count; _dirOffset = 180;};
    case (_count > 5 && _count <= 8): {_dirIncrease = 240/_count; _dirOffset = 150;};
    case (_count > 8): {_dirIncrease = 360/_units; _dirOffset = 0;};
};

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
        private _dir = (getDir _vehicle) + (_dirOffset + random 10 - 5);
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
