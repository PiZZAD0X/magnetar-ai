/*
 * Author: TheMagnetar
 * Spawn PFH.
 *
 * Arguments:
 * 0: Parameters <ARRAY>
 * 1: PerFrameHandler identifier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], 2] call mai_spawn_fnc_spawnGroupPFH
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_group", "_handle"];

private _unitsToSpawn = _group getVariable [QGVAR(unitsToSpawn), []];
if (_unitsToSpawn isEqualTo []) exitWith {
    [_handle] call CBA_fnc_removePerFrameHandler;
    _group setVariable [QGVAR(position), nil];

    private _settings = _group getVariable [QEGVAR(core,settings), []];
    [_group, _settings] call EFUNC(core,applyOptions);

    _group setVariable [QEGVAR(core,settings), _settings, true];
    _group setVariable [QEGVAR(core,enabled), true, true];

    // Register the group
    private _marker = [_settings, "marker"] call CBA_fnc_hashGet;
    [QGVAR(registerGroup), [_group, _marker]] call CBA_fnc_localEvent;
};

private _unitType = _unitsToSpawn deleteAt 0;

if (_unitType isEqualType "") then {
    private _spawnedUnit = _group createUnit [_unitType, [0,0,0], [], 0, "CAN_COLLIDE"];
    if (isNull (_group getVariable [QEGVAR(core,leader), objNull])) then {
        _group selectLeader _spawnedUnit;
        _group setVariable [QEGVAR(core,leader), _spawnedUnit];
    };
} else {
    if (_unitType isKindOf "CAManBase") then {

    } else {

    };
};
