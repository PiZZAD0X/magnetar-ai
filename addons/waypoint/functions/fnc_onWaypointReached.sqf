/*
 * Author: TheMagnetar
 * Generates a waypoint.
 *
 * Arguments:
 * 0: Group <OBJECT> (default: [])
 * 1: Vehicle type <NUMBER> (default: 0)
 * 1: List of options <ARRAY> (default: [])
 *
 * Return Value:
 * Waypoint successful <BOOL>
 *
 * Example:
 * [group player] call mai_waypoint_fnc_generateWaypoint
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_group"];

private _settings = _group getVariable [QEGVAR(core,settings), []];

if (_settings isEqualTo []) exitWith {
    WARNING_1("Group %1 defined without configuration",_settings);
};

_group setCombatMode (selectRandom ([_settings, "combatMode"] call CBA_fnc_hashGet));
_group setFormation (selectRandom ([_settings, "formation"] call CBA_fnc_hashGet));
_group setSpeedMode (selectRandom ([_settings, "speed"] call CBA_fnc_hashGet));

switch ([_settings, "type"] call CBA_fnc_hashGet) do {
    case "infantry": {

    };
    case "wheeled": {

    };
    case "armored": {

    };
    case "air": {

    };
    case "boat": {

    };
};

[_group] call FUNC(generateWaypoint);
