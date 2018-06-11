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

params ["_modelGroup", ["_sleep", 0.05]];

private _side = side _modelGroup;
private _grp = createGroup _side;

private _settings =+ _modelGroup getVariable [QEGVAR(core,settings), []];

// Define random position
private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;
private _grpPosition = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50]] call EFUNC(waypoint,markerRandomPos);

// Generate units
{
    private _type = typeOf _x;
    private _pos = _grpPosition findEmptyPosition [0, 50, _type];
    private _unit = _grp createUnit [_x, _pos, [], 2, "NONE"];
    _unit setSkill (skill _x);

    if (leader _modelGroup == _x) then {
        _grp setLeader _unit;
    };
} forEach (units _group);

// Reset task states and assign behaviour, speed, ...
_grp setBehaviour (selectRandom ([_settings, "behaviour"] call CBA_fnc_hashGet));
_grp setCombatMode (selectRandom ([_settings, "combatMode"] call CBA_fnc_hashGet));
_grp setFormation (selectRandom ([_settings, "formation"] call CBA_fnc_hashGet));
_grp setSpeedMode (selectRandom ([_settings, "speed"] call CBA_fnc_hashGet));

// Init line
_grp call compile ([_settings, "init"] call CBA_fnc_hashGet);

// Reset task
[_settings, "taskState", "init"] call CBA_fnc_hashSet;

_grp setVariable [QEGVAR(core,settings), _settings, true];

[{CBA_missionTime > 0}, {
    params ["_group"];
    private _pfh =  _group getVariable [QEGVAR(core,pfh), -1];
    
    if (_pfh != -1) then {
        _pfh = [DEFUNC(core,mainPFH), 0, _group] call CBA_fnc_addPerFrameHandler;
    };
    _group setVariable [QEGVAR(core,pfh), _pfh, true];
}, _group] call CBA_fnc_waitUntilAndExecute;

_grp
