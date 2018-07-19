/*
 * Author: TheMagnetar
 * Spawns a group with randomised unit composition.
 *
 * Arguments:
 * 0: Config entry <STRING>
 * 1: Group size either in [min, max] format or a defined number <ARRAY><NUMBER>
 * 2: Marker <STRING>
 * 3: Position <ARRAY> (default: [])
 * 4: Speel time between unit creation <NUMBER> (default: 0.05)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["infantryUSMC", [2, 5], "marker"] call mai_spawn_fnc_randSpawnGroup
 ^ ["infantryUSMC", 4, "marker", getPos player] call mai_spawn_fnc_randSpawnGroup
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_configEntry", ["_groupSize", 0], "_marker", ["_position", []], ["_sleep", 0.05]];

if (getMarkerColor _marker == "") exitWith {
    ERROR_1("marker %1 does not exist", _marker);
};

// Basic options should be always defined
private _options = [];
{
    private _values = getArray (missionConfigFile >> "CfgGroupCompositions" >> _configEntry >> _x);
    _options pushBack [_x, _values];
} forEach ["behaviour", "combatMode", "formation", "speed", "skill", "skillLeader"];

// Additional options defined in config
private _options =+ getArray (missionConfigFile >> "CfgGroupCompositions" >> _configEntry >> "options");

// Init settings for the group
private _settings = [] call CBA_fnc_hashCreate;
private _type = toLower (getText (missionConfigFile >> "CfgGroupCompositions" >> _configEntry >> "type"));
_settings = [_settings, _marker, _type] call EFUNC(core,setBasicSettings);
_settings = [_settings, _options] call EFUNC(core,parseOptions);

private _determineSize = {
    params ["_grpSize"];

    private _size = 0;
    if (_grpSize isEqualType []) then {
        _grpSize params ["_minSize", "_maxSize"];
        _size = _minSize + floor (random (_maxSize - _minSize));
    } else {
        _size = _grpSize;
    };

    _size
};

// Determine group size
private _size = 0;
if (_groupSize isEqualType []) then {
    if (_type isEqualTo "infantry") then {
        _size = [_groupSize] call _determineSize;
    } else {
        _groupSize params ["_gSize", "_cargoSize"];
        _size = [[_groupSize # 0] call _determineSize, [_groupSize # 1] call _determineSize];
    };
} else {
    _size = _groupSize;
};

// Determine group side
private _side = getText (missionConfigFile >> "CfgGroupCompositions" >> _configEntry >> "side");

// Generate units
if (_type isEqualTo "infantry") then {
    [_configEntry, _settings, _side, _size, _marker, _sleep, _position] call FUNC(helperSpawnInfantry);
} else {
    [_configEntry, _settings, _side, _size, _marker, _sleep, _position] call FUNC(helperSpawnVehicle);
};
