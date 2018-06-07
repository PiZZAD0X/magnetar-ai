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
 * [group player] call mai_tasks_fnc_patrol
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group"];

[_group] call EFUNC(waypoint,generateWaypoint);

