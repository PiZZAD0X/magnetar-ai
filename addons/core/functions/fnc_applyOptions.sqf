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

private _templateName = [_settings, "createTemplate"] call CBA_fnc_hashGet;
if !(_templateName isEqualTo "") then {
    [_group, _templateName, _settings] call FUNC(createTemplate);
};

// Handle spawn and waypoint markers
private _markers =  [_settings, "marker"] call CBA_fnc_hashGet;
private _deleteSpawnMarkers = [_settings, "deletespawnmarkers"] call CBA_fnc_hashGet;
private _waypointMarkers = [_settings, "waypointmarkers"] call CBA_fnc_hashGet;

if (_deleteSpawnMarkers) then {
    if !(_waypointMarkers isEqualTo []) then {
        _markers = [];
    } else {
        ERROR_1("Delete spawn markers option was active for group %1 without specifying additional waypoint markers",_group);
    };
};

_markers append _waypointMarkers;

_markers = [_markers] call EFUNC(waypoint,organizeMarkers);
