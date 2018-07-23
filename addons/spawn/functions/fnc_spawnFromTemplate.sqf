/*
 * Author: TheMagnetar
 * Creates a group template.
 *
 * Arguments:
 * 0: Model group <OBJECT>
 * 1: Template name <STRING>
 * 2: Additional options for the group <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group1, 3, [["task", "attack"], ["forceRoads", true]], 0.1] call mai_spawn_fnc_cloneGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_templateName", "_marker", "_numGroups", ["_position", []], ["_overrideOptions", []]];

private _template = [QGVAR(groupTemplates), "_templateName"] call CBA_fnc_hashGet;
if !(_template isEqualType []) exitWith {
    ERROR_1("Undefined template name %1",_templateName);
};

_tempate params ["_side", "_settings", "_units"];

// Determine group size
private _num = 0;
if (_numGroups isEqualType []) then {
    _numGroups params ["_minSize", "_maxSize"];
    _num = _minSize + floor (random (_maxSize - _minSize));
} else {
    _num = _numGroups;
};

if (_overrideOptions isEqualTo []) then {
    [_settings, _overrideOptions] call EFUNC(core,parseOptions);
};

for "_i" from 1 to _num {
    GVAR(spawnQueue) pushBack [_units, _marker, [_settings, "type"] call CBA_fnc_hashGet, _side, 0, _position, _settings, []];
};

