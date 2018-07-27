/*
 * Author: TheMagnetar
 * Clones the units of a group.
 *
 * Arguments:
 * 0: Group to clone <OBJECT>
 * 1: Template name <STRING>
 * 2: Settings <HASH>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group1, 3, [["task", "attack"], ["forceRoads", true]], 0.1] call mai_spawn_fnc_createTemplate
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_modelGroup", ["_templateName", ""], ["_settings", []], ["_overrideOptions", []]];

if (_templateName isEqualTo "") exitWith {
    ERROR("Empty template name");
};

if (isClass (missionConfigFile >> "CfgGroupCompositions" >> _configEntry)) exitWith {
    ERROR_1("Template name %1 already defined as config entry",_configEntry);
};

private _side = format ["%1", side _modelGroup];
if (_settings isEqualTo []) then {
    _settings =+ (_modelGroup getVariable [QGVAR(settings), []]);
};

[_settings, "template", _templateName] call CBA_fnc_hashSet;

private _type = toLower ([_settings, "type"] call CBA_fnc_hashGet);

private _helperFunction = missionNamespace getVariable QFUNC(helperTemplateInfantry);

if !(_type isEqualTo "infantry") then {
    _helperFunction = missionNamespace getVariable QFUNC(helperTemplateVehicle);
};

private _templateValues = [_modelGroup] call _helperFunction;

_templateValues params ["_units", "_loadout", "_rank", "_skill"];

[GVAR(groupTemplates), _templateName, [_side, _settings, _units, _loadout, _rank, _skill]] call CBA_fnc_hashSet;
