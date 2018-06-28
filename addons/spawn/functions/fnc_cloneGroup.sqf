/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Group to clone <OBJECT>
 * 1: Sleep time between unit creation <NUMBER> (default: 0.05)
 *
 * Return Value:
 * Group <OBJECT>
 *
 * Example:
 * [player] call mai_spawn_fnc_cloneGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_modelGroup", "_numClones", ["_overrideOptions", []], ["_sleep", 0.05]];

private _side = side _modelGroup;
private _group = createGroup _side;

private _settings =+ _modelGroup getVariable [QEGVAR(core,settings), []];

// Define random position
private _marker = [_settings, "marker"] call CBA_fnc_hashGet;
private _allowWater = [_settings, "allowWater"] call CBA_fnc_hashGet;
private _allowLand = [_settings, "allowLand"] call CBA_fnc_hashGet;
private _forceRoads = [_settings, "forceRoads"] call CBA_fnc_hashGet;

if (_overrideOptions isEqualTo []) then {
    [_settings, _overrideOptions] call EFUNC(core,parseOptions);
};

// Determine group size
private _num = 0;
if (_numClones isEqualType []) then {
    _numClones params ["_minSize", "_maxSize"];
    _num = _minSize + floor (random (_maxSize - _minSize));
} else {
    _num = _numClones;
};
private _type = toLower ([_settings, "type"] call CBA_fnc_hashGet);

private _helperFunction = missionNamespace getVariable QFUNC(helperCloneInfantry);

if !(_type isEqualTo "infantry") then {
    _helperFunction = missionNamespace getVariable QFUNC(helperCloneVehicle);
}

for "_i" from 1 to _num do {
    private _groupPosition = [_marker, [_allowWater, _allowLand, _forceRoads], [0, 50]] call EFUNC(waypoint,markerRandomPos);
    
    [_modelGroup, _group, _groupPosition, _sleep] spawn _helperFunction;

    // Reset task states and assign behaviour, speed, ...
    _group setBehaviour (selectRandom ([_settings, "behaviour"] call CBA_fnc_hashGet));
    _group setCombatMode (selectRandom ([_settings, "combatMode"] call CBA_fnc_hashGet));
    _group setFormation (selectRandom ([_settings, "formation"] call CBA_fnc_hashGet));
    _group setSpeedMode (selectRandom ([_settings, "speed"] call CBA_fnc_hashGet));

    // Init
    [_group, _settings] call EFUNC(core,applyOptions);
    _group setVariable [QEGVAR(core,settings), _settings];
    _group setVariable [QEGVAR(core,enabled), true];

    // Register the group
    [QEGVAR(core,registerGroup), [_group, _marker]] call CBA_fnc_serverEvent;
};

_group
