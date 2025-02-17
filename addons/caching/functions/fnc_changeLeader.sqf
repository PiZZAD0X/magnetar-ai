/*
 * Author: TheMagnetar
 * Handles changing the leader while unit is cached
 *
 * Arguments:
 * 0: Group <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [group1] call mai_cache_fnc_changeLeader
 *
 * Public: No
 */
#include "script_component.hpp"
EXEC_CHECK(SERVERHC);

params ["_group"];

[_group] call FUNC(uncacheGroup);
private _leader = leader _group;
_group setVariable [QEGVAR(core,leader), _leader];

[_group] call FUNC(cacheGroup);

[QGVAR(cache), _group] call CBA_fnc_localEvent;
