/*
 * Author: TheMagnetar
 * Suspend all AI management.
 *
 * Arguments:
 * 0: Group <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_core_fnc_suspend
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_group"];

private _pfh = _group getVariable [QGVAR(pfh), -1];
[_pfh] call CBA_fnc_removePerFrameHandler;
