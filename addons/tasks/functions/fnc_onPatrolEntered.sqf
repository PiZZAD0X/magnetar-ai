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
if (_group getVariable [QGVAR(patrolFinished), false]) then {

    private _perimeterSettings = _group getVariable [QGVAR(perimeterSetings), [_settings, "perimeterSettings"] call CBA_fnc_hashGet];
    _perimeterSettings params ["_center", "_radius"];
    private _execStatements = "";
    private _condition = "true";

    [_group, _center, _radius, ["MOVE", _execStatements, _condition]] call EFUNC(waypoint,generatePerimeterWaypoints);
} else {
    // If patrol is a subtask of the groups main assignement,return to it.
    if !([_settings, "task"] call CBA_fnc_hashGet isEqualTo QGVAR(patrol)) then {
        [QGVAR(doTask), _group] call CBA_fnc_localEvent;
    };
};
