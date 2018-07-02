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
 * [group player] call mai_tasks_fnc_onEmbarkStateEntered
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_state"];

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _perimeterSettings = _group getVariable [QGVAR(perimeterSetings), [_settings, "perimeterSettings"] call CBA_fnc_hashGet];

_perimeterSettings params ["_center", "_radius"];

[_group, _center, _radius] call EFUNC(waypoint,generatePerimeterWaypoints);
