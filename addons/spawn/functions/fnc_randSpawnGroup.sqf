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

private _grp = createGroup _side;

// Determine group size
private _size = 0;
if (isArray _groupSize) then {
    _groupSize params ["_minSize", "_maxSize"];
    _size = _minSize + floor (random (_maxSize - _minSize));
} else {
    _size = _groupSize;
};

// Basic options should be always defined
private _options = [];
{
    private _values = getArray ("CfgGroupCompositions" >> _configEntry >> _x);
    _options pushBack [_x, _values];
} forEach ["behaviour", "combatMode", "formation", "speed", "skill"];

// Additional options defined in config
private _options += getArray ("CfgGroupCompositions" >> _configEntry >> "options");

private _settings = [] call CBA_fnc_hashCreate;
_settings = [_settings, _marker, _type] call EFUNC(core,setBasicSettings);

// Init all group options
[_grp, _settings, _options] call EFUNC(core,handleOptions);

// Gnerate units
private _type = getText ("CfgGroupCompositions" >> _configEntry >> "type");
[_grp, _configEntry, _size, _marker, _sleep] call (missionNamespace getVariable [QGVAR(helperSpawn%1), toLower _type]);

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

_grp
