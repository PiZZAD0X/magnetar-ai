/*
 * Author: TheMagnetar
 * Handle garrison entered state
 *
 * Arguments:
 * 0: Group <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [nearestBuilding player] call mai_tasks_fnc_onGarrisonEntered
 *
 * Public: No
 */
 #include "script_component.hpp"
 EXEC_CHECK(SERVERHC);

params ["_group"];

private _inBuilding = [_group, true] call EFUNC(building,moveInBuilding);

if !(_inBuilding) exitWith {
    private _settings = _group getVariable [QEGVAR(core,settings), []];
    [_settings, "task", "patrol"] call CBA_fnc_hashSet;
    [_settings, "perimeterSettings", [getPos (leader _group), 100]] call CBA_fnc_hashSet;
    _group setVariable [QEGVAR(core,settings), _settings];
    [group this, QGVAR(taskPatrol)] call FUNC(changeAssignedTask);
    [QGVAR(patrolBuildings), _group] call CBA_fnc_localEvent;

    private _marker = [_settings, "marker"] call CBA_fnc_hashGet;
    WARNING_3("No building for group in %1 (Garrisson). Switching to patrol with center %2 and radius %3.",_marker,getPos (leader _group),100);
};

_group setVariable [QGVAR(inBuilding), true];
