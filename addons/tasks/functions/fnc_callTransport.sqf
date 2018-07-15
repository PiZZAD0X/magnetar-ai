/*
 * Author: TheMagnetar
 * Checks if a group should start doing something
 *
 * Arguments:
 * 0: Group <OBJECT>
 *
 * Return Value:
 * Do task? <BOOL>
 *
 * Example:
 * [group player] call mai_tasks_fnc_checkDoTask
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_type"];

if (_type isEqualTo "infantry") then {
    _unitCount = count (units _group);
};

// Check if a transport is available within a certain radius
private _availableGroups = [];
private _enabledGroups = allGroups select {_x getVariable [QEGVAR(core,enabled), false)]};
{
    private _settings = _x getVariable [QEGVAR(core,settings), []];
    private _task = [_settings, "task"] call CBA_fnc_hashGet;
    if (_task isEqualTo "transport" && {!(_x getVariable [QGVAR(inMission), false])}) then {
        // Check if the transport can go to the designated coordinates
        private _positionAllowed = false;

        _targetPos = waypointPosition [_group, 0];
        if (surfaceIsWater _targetPos && {[_settings, "allowWater"] call CBA_fnc_hashGet}) then {
            _positionAllowed = true;
        };

        if (!surfaceIsWater && {[_settings, "allowLand"] call CBA_fnc_hashGet}) then {
            _positionAllowed = true;
        };


        if (_positionAllowed) then {
            // Check if the vehicle transport has enough empty cargo spaces
            private _vehicle = vehicle (leader _group);
            private _availablePositions = 0;

            {
                if (isNull (_x # 0)) then {
                    _availablePositions = _availablePositions + 1;
                };
            } fullCrew [_vehicle, "cargo", true];

            if (_availablePositions >= _unitCount) then {
                _availableGroups pushBack [_group, [_settings, "type"] call CBA_fnc_hashGet];
            };


        };

    };
} forEach _enabledGroups;
