/*
 * Author: TheMagnetar
 * Initialises a group.
 *
 * Arguments:
 * 0: Unit <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call mai_core_fnc_init
 *
 * Public: No
 */
#include "script_component.hpp"

params [["_unit", objNull], "_marker", ["_type", "infantry"], ["_options", []]];

private _group = group _unit;

if (!local (leader _group)) exitWith {};


// Create default values for the group
private _settings = [] call CBA_fnc_hashCreate;

[_settings, "marker", _marker] call CBA_fnc_hashSet;
[_settings, "type", _type] call CBA_fnc_hashSet;
[_settings, "behaviour", [behaviour _group]] call CBA_fnc_hashSet;
[_settings, "combatMode", [combatMode _group]] call CBA_fnc_hashSet;
[_settings, "formation", [formation _group]] call CBA_fnc_hashSet;
[_settings, "speed", [speedMode _group]] call CBA_fnc_hashSet;
[_settings, "task", "patrol"] call CBA_fnc_hashSet;
[_settings, "allowWater", false] call CBA_fnc_hashSet;
[_settings, "forceRoads", false] call CBA_fnc_hashSet;
[_settings, "randomBehaviour", true] call CBA_fnc_hashSet;
[_settings, "waitAtWaypoint", true] call CBA_fnc_hashSet;
[_settings, "allowVehicles", true] call CBA_fnc_hashSet;
[_settings, "patrolBuildings", true] call CBA_fnc_hashSet;

[_group, _settings, _options] call FUNC(handleOptions);

_group setVariable [QGVAR(settings), _settings, true];

[QGVAR(registerGroup), _group] call CBA_fnc_serverEvent;

if (GVAR(mainLoopPFH) == -1) then {
    GVAR(mainLoopPFH) = [DFUNC(mainPFH), 0, [_group]] call CBA_fnc_addPerFrameHandler;
};
