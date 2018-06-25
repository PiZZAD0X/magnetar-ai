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
 * Public: Yes
 */
#include "script_component.hpp"

params [["_unit", objNull], "_marker", ["_type", "infantry"], ["_options", []]];

private _group = group _unit;

if (!local (leader _group)) exitWith {};

// Create default values for the group
private _settings = [] call CBA_fnc_hashCreate;
_settings = [_settings, _marker, _type] call FUNC(setBasicSettings);
systemChat format ["%1", _settings];

[_settings, "behaviour", [behaviour (leader _group)]] call CBA_fnc_hashSet;
[_settings, "combatMode", [combatMode _group]] call CBA_fnc_hashSet;
[_settings, "formation", [formation _group]] call CBA_fnc_hashSet;
[_settings, "speed", [speedMode _group]] call CBA_fnc_hashSet;

[_group, _settings, _options] call FUNC(handleOptions);
[_group, _settings] call FUNC(applyOptions);
_group setVariable [QGVAR(enabled), true];

// Register the group
[QGVAR(registerGroup), _group] call CBA_fnc_serverEvent;

/*
[{CBA_missionTime > 0}, {
    params ["_group"];
    private _pfh =  _group getVariable [QGVAR(pfh), -1];

    if (_pfh == -1) then {
        _pfh = [DFUNC(mainPFH), 0, _group] call CBA_fnc_addPerFrameHandler;
    };
    _group setVariable [QGVAR(pfh), _pfh, true];
}, _group] call CBA_fnc_waitUntilAndExecute;
*/
