/*
 * Author: TheMagnetar
 * Spawns a random group of units.
 *
 * Arguments:
 * 0: Unit <OBJECT> (Default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call mai_spawn_fnc_spawnInfantryGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_configEntry", "_groupSize", "_marker", ["_sleep", 0.05]];

private _side = getText (configFile >> "CfgGroupCompositions" >> _configEntry >> "side");
private _group = objNull;
systemChat format ["side %1", _side];
switch (toLower _side) do {
    case "west": {_group = createGroup west};
    case "east": {_group = createGroup east};
    case "independent": {_group = createGroup independent};
    case "civilian": {_group = createGroup civilian};
};

// Determine group size
private _size = 0;
if (_groupSize isEqualType []) then {
    _groupSize params ["_minSize", "_maxSize"];
    _size = _minSize + floor (random (_maxSize - _minSize));
} else {
    _size = _groupSize;
};
systemChat format ["size %1", _size];
// Basic options should be always defined
private _options = [];
{
    private _values = getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> _x);
    _options pushBack [_x, _values];
} forEach ["behaviour", "combatMode", "formation", "speed", "skill", "skillLeader"];

// Additional options defined in config
private _options =+ getArray (configFile >> "CfgGroupCompositions" >> _configEntry >> "options");

private _settings = [] call CBA_fnc_hashCreate;
private _type = getText (configFile >> "CfgGroupCompositions" >> _configEntry >> "type");
_settings = [_settings, _marker, _type] call EFUNC(core,setBasicSettings);
systemChat format ["type %1", _type];
// Init all group options
[_group, _settings, _options] call EFUNC(core,handleOptions);

// Gnerate units
systemChat format [QFUNC(helperSpawn%1), toLower _type];
[_group, _configEntry, _size, _marker, _sleep] call (missionNamespace getVariable (format [QFUNC(helperSpawn%1), _type]));

// Apply basic options
[_group, _settings] call EFUNC(core,applyOptions);

[{CBA_missionTime > 0}, {
    params ["_group"];
    private _pfh =  _group getVariable [QEGVAR(core,pfh), -1];

    if (_pfh != -1) then {
        _pfh = [DEFUNC(core,mainPFH), 0, _group] call CBA_fnc_addPerFrameHandler;
    };
    _group setVariable [QEGVAR(core,pfh), _pfh, true];
}, _group] call CBA_fnc_waitUntilAndExecute;

_group
