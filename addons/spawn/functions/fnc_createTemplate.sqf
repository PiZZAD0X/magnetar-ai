/*
 * Author: TheMagnetar
 * Clones the units of a group.
 *
 * Arguments:
 * 0: Group to clone <OBJECT>
 * 1: Template name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group1, 3, [["task", "attack"], ["forceRoads", true]], 0.1] call mai_spawn_fnc_cloneGroup
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_modelGroup", ["_templateName", ""], ["_overrideOptions", []]];

if (_templateName isEqualTo "") exitWith {
    ERROR("Empty template name");
};

private _side = side _modelGroup;
private _settings =+ (_modelGroup getVariable [QEGVAR(core,settings), []]);
["_settings", "template", _templateName] call CBA_fnc_hashSet;

private _type = toLower ([_settings, "type"] call CBA_fnc_hashGet);

private _helperFunction = missionNamespace getVariable QFUNC(helperTemplateInfantry);

if !(_type isEqualTo "infantry") then {
    _helperFunction = missionNamespace getVariable QFUNC(helperTemplateVehicle);
};

_templateValues = [_modelGroup] spawn _helperFunction;

_templateValues params ["_units", "_loadout", "_rank", "_skill"];

[QGVAR(groupTemplates), _templateName, [_side, _settings, _units, _loadout, _rank, _skill]] call CBA_fnc_hashSet;
