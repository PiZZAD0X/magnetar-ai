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
 * [group player] call mai_tasks_fnc_onWaypointStateEntered
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_state"];

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _targetPos = [_group, [_settings, "marker"] call CBA_fnc_hashGet] call EFUNC(waypoint,generateWaypoint);

[QGVAR(patrol), _group] call CBA_fnc_localEvent;
