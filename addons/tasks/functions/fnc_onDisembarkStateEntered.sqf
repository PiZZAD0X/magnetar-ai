/*
 * Author: TheMagnetar
 * Task patrol.
 *
 * Arguments:
 * 0: Group <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_tasks_fnc_onDisembarkEntered
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_state"];

[_group, false, true, false] call EFUNC(vehicle,disembark);
