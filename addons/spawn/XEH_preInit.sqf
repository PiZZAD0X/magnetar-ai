#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

#include "initSettings.sqf"

EXEC_CHECK(SERVERHC);

GVAR(spawnGroupPFH) = -1;
GVAR(spawnQueue) = [];

ADDON = true;
