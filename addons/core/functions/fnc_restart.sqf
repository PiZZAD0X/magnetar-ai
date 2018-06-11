/*
 * Author: TheMagnetar
 * Reenables all AI management.
 *
 * Arguments:
 * 0: Group <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_core_fnc_restart
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_group"];

[QGVAR(targetPFH), _group, leader _group] call CBA_fnc_targetEvent;
