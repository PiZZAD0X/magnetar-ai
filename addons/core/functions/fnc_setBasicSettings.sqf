/*
 * Author: TheMagnetar
 * Sets the basic setting parameters.
 *
 * Arguments:
 * 0: Settings <HASH>
 *
 * Return Value:
 * Hash with basic settings <HASH>
 *
 * Example:
 * [[]] call mai_core_fnc_init
 *
 * Public: No
 */

params ["_settings", "_marker", "_type"];

if ([_settings] call CBA_fnc_isHash) exitWith {
    WARNING_1("Passed argument is not a valid CBA Hash: %1",_settings);
    _settings
};

[_settings, "marker", _marker] call CBA_fnc_hashSet;
[_settings, "type", _type] call CBA_fnc_hashSet;

[_settings, "task", "patrol"] call CBA_fnc_hashSet;
[_settings, "taskState", "init"] call CBA_fnc_hashSet;

[_settings, "allowWater", false] call CBA_fnc_hashSet;
[_settings, "allowLand", true] call CBA_fnc_hashSet;
[_settings, "forceRoads", false] call CBA_fnc_hashSet;

[_settings, "randomBehaviour", true] call CBA_fnc_hashSet;
[_settings, "waitAtWaypoint", true] call CBA_fnc_hashSet;
[_settings, "allowVehicles", true] call CBA_fnc_hashSet;
[_settings, "patrolBuildings", true] call CBA_fnc_hashSet;
[_settings, "inBuilding", false] call CBA_fnc_hashSet;

_settings
