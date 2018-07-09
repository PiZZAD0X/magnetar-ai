/*
 * Author: TheMagnetar
 * Executed when units enter the Patrol Random state.
 *
 * Arguments:
 * 0: Group <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group player] call mai_tasks_fnc_onPatrolRandomStateEntered
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_state"];

private _settings = _group getVariable [QEGVAR(core,settings), []];
private _reachedDistance = [_settings, "reachedDistance"] call CBA_fnc_hashGet;
private _execStatements = "";

if ([_settings, "waitAtWaypoint"] call CBA_fnc_hashGet) then {
    private _unitType = [_settings, "type"] call CBA_fnc_hashGet;

    if (_unitType isEqualTo "infantry") then {
        _execStatements = QUOTE([ARR_2(QQGVAR(wait), _group)] call CBA_fnc_localEvent);
    } else {
        private _vehicle = vehicle (leader _group);
        if (speed _vehicle == 0) then {
            _execStatements = QUOTE([ARR_2(QQGVAR(disembark), [ARR_4(_group, true, true, false)])] call CBA_fnc_localEvent);
        };
    };
} else {
    _execStatements = QUOTE([ARR_2(QQGVAR(doTask), _group)] call CBA_fnc_localEvent);
};

private _marker = [_settings, "marker"] call CBA_fnc_hashGet;
private _targetPos = [_group, _marker, ["MOVE", _execStatements]] call EFUNC(waypoint,generateWaypoint);
_group setVariable [QGVAR(distance), (getPos (leader _group)) distance2D _targetPos];
