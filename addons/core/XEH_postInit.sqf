#include "script_component.hpp"

[QGVAR(registerGroup), {
    params ["_group"];

    private _settings = _group getVariable [QGVAR(settings), []];
    [_settings, "groupId", GVAR(groupRegisters)] call CBA_fnc_hashSet;
    _group setVariable [QGVAR(settings), _settings, true];

    GVAR(groupRegisters) = GVAR(groupRegisters) + 1;
}] call CBA_fnc_addEventHandler;

[QGVAR(targetPFH), {
    params ["_group"];

    private _pfh = [DFUNC(mainPFH), 0, _group] call CBA_fnc_addPerFrameHandler;
    _group setVariable [QGVAR(pfh), _pfh, true];
}] call CBA_fnc_addEventHandler;
