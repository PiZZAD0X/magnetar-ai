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

params [["_unit", objNull], ["_options", []]];

if (!local _unit) exitWith {};

_grp = group _unit;
_grp = GVAR(groupId)

[_grp, _options] call FUNC(handleOptions);
