/*
 * Author: TheMagnetar
 * Applies the settings to the group before units are spawned
 *
 * Arguments:
 * 0: Group <OBJECT> (Default: objNull)
 * 1: Settings <HASH>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_core_fnc_applyOptionsPreSpawn
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", ["_settings", []]];

// PreSpawn code
[_group] call compile ([_settings, "preSpawn"] call CBA_fnc_hashGet);

[_group, _settings] call FUNC(handleStartPosition);
