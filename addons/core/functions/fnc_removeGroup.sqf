/*
 * Author: TheMagnetar
 * Removes a group from the AI management addon
 *
 * Arguments:
 * 0: Group <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_core_fnc_removeGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_group"];

_group setVariable [QGVAR(enabled), false];
