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

private _settings =+ _modelGroup getVariable [QEGVAR(core,settings), []], true];

// Generate units

// Reset task states and assign behaviour, speed, ...
_grp setBehaviour (selectRandom ([_settings, "behaviour"] call CBA_fnc_hashGet));
_grp setCombatMode (selectRandom ([_settings, "combatMode"] call CBA_fnc_hashGet));
_grp setFormation (selectRandom ([_settings, "formation"] call CBA_fnc_hashGet));
_grp setSpeedMode (selectRandom ([_settings, "speed"] call CBA_fnc_hashGet));
[_grp, [_settings, "skill"] call CBA_fnc_hashGet] call EFUNC(core,setskill);

// Init line
_grp call compile ([_settings, "init"] call CBA_fnc_hashGet);

// Reset task
[_settings, "taskState", "init"] call CBA_fnc_hashSet;

_grp setVariable [QEGVAR(core,settings), _settings, true];

_grp
