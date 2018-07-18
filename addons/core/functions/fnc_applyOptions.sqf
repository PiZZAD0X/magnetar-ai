/*
 * Author: TheMagnetar
 * Applies the settings to the group.
 *
 * Arguments:
 * 0: Group <OBJECT> (Default: objNull)
 * 1: Settings <HASH>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player call mai_core_fnc_applyOptions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", ["_settings", []]];

if (_settings isEqualTo []) then {
    _settings = _group getVariable [QGVAR(settings), []];
};

_group setBehaviour (selectRandom ([_settings, "behaviour"] call CBA_fnc_hashGet));
_group setCombatMode (selectRandom ([_settings, "combatMode"] call CBA_fnc_hashGet));
_group setFormation (selectRandom ([_settings, "formation"] call CBA_fnc_hashGet));
_group setSpeedMode (selectRandom ([_settings, "speed"] call CBA_fnc_hashGet));

private _skill = [_settings, "skill"] call CBA_fnc_hashGet;
private _skillLeader = [_settings, "skillLeader"] call CBA_fnc_hashGet;
[_group, [_skill, _skillLeader]] call FUNC(setSkill);

// Init settings
[_group] call compile ([_settings, "init"] call CBA_fnc_hashGet);

if ([_settings, "randomPosition"] call CBA_fnc_hashGet) then {
    private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
    private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
    private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;
    private _position = [];

    if (units _group isEqualTo []) then {
        _position = [_marker, [_allowWater, _allowLand, _forceRoads]] call EFUNC(waypoint,markerRandomPos);
    } else {
        // Select a unit
        private _vehicleIndex = (units _group) findIf {!(_x isKindOf "CAManBase")};
        private _unit = objNull;

        if ( _vehicleIndex != -1) then {
            _unit = (units _group) # _vehicleIndex;
        } else {
            _unit = (units _group) # 0;
        };

        _position = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, typeOf _unit]] call EFUNC(waypoint,markerRandomPos);
    };

    _group setVariable [QGVAR(position), _position];
};

if ([_settings, "spawnInBuilding"] call CBA_fnc_hashGet) then {
    private _position = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50, typeOf _unit]] call EFUNC(waypoint,markerRandomBuildingPos);
};
