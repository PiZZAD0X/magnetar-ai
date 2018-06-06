/**
FAST RECOMPILING
**/
// #define DISABLE_COMPILE_CACHE
// To Use: [] call MAI_PREP_RECOMPILE;

#ifdef DISABLE_COMPILE_CACHE
    #define LINKFUNC(x) {_this call FUNC(x)}
    #define PREP_RECOMPILE_START    if (isNil "MAI_PREP_RECOMPILE") then {MAI_RECOMPILES = []; MAI_PREP_RECOMPILE = {{call _x} forEach MAI_RECOMPILES;}}; private _recomp = {
    #define PREP_RECOMPILE_END      }; call _recomp; MAI_RECOMPILES pushBack _recomp;
#else
    #define LINKFUNC(x) FUNC(x)
    #define PREP_RECOMPILE_START /* disabled */
    #define PREP_RECOMPILE_END /* disabled */
#endif


/**
STACK TRACING
**/
//#define ENABLE_CALLSTACK
//#define ENABLE_PERFORMANCE_COUNTERS
//#define DEBUG_EVENTS

#ifdef ENABLE_CALLSTACK
    #define CALLSTACK(function) {private ['_ret']; if (MAI_IS_ERRORED) then { ['AUTO','AUTO'] call MAI_DUMPSTACK_FNC; MAI_IS_ERRORED = false; }; MAI_IS_ERRORED = true; MAI_STACK_TRACE set [MAI_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, MAI_CURRENT_FUNCTION, 'ANON', _this]]; MAI_STACK_DEPTH = MAI_STACK_DEPTH + 1; MAI_CURRENT_FUNCTION = 'ANON'; _ret = _this call ##function; MAI_STACK_DEPTH = MAI_STACK_DEPTH - 1; MAI_IS_ERRORED = false; _ret;}
    #define CALLSTACK_NAMED(function, functionName) {private ['_ret']; if (MAI_IS_ERRORED) then { ['AUTO','AUTO'] call MAI_DUMPSTACK_FNC; MAI_IS_ERRORED = false; }; MAI_IS_ERRORED = true; MAI_STACK_TRACE set [MAI_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, MAI_CURRENT_FUNCTION, functionName, _this]]; MAI_STACK_DEPTH = MAI_STACK_DEPTH + 1; MAI_CURRENT_FUNCTION = functionName; _ret = _this call ##function; MAI_STACK_DEPTH = MAI_STACK_DEPTH - 1; MAI_IS_ERRORED = false; _ret;}
    #define DUMPSTACK ([__FILE__, __LINE__] call MAI_DUMPSTACK_FNC)

    #define FUNC(var1) {private ['_ret']; if (MAI_IS_ERRORED) then { ['AUTO','AUTO'] call MAI_DUMPSTACK_FNC; MAI_IS_ERRORED = false; }; MAI_IS_ERRORED = true; MAI_STACK_TRACE set [MAI_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, MAI_CURRENT_FUNCTION, 'TRIPLES(ADDON,fnc,var1)', _this]]; MAI_STACK_DEPTH = MAI_STACK_DEPTH + 1; MAI_CURRENT_FUNCTION = 'TRIPLES(ADDON,fnc,var1)'; _ret = _this call TRIPLES(ADDON,fnc,var1); MAI_STACK_DEPTH = MAI_STACK_DEPTH - 1; MAI_IS_ERRORED = false; _ret;}
    #define EFUNC(var1,var2) {private ['_ret']; if (MAI_IS_ERRORED) then { ['AUTO','AUTO'] call MAI_DUMPSTACK_FNC; MAI_IS_ERRORED = false; }; MAI_IS_ERRORED = true; MAI_STACK_TRACE set [MAI_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, MAI_CURRENT_FUNCTION, 'TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)', _this]]; MAI_STACK_DEPTH = MAI_STACK_DEPTH + 1; MAI_CURRENT_FUNCTION = 'TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)'; _ret = _this call TRIPLES(DOUBLES(PREFIX,var1),fnc,var2); MAI_STACK_DEPTH = MAI_STACK_DEPTH - 1; MAI_IS_ERRORED = false; _ret;}
#else
    #define CALLSTACK(function) function /* disabled */
    #define CALLSTACK_NAMED(function, functionName) function /* disabled */
    #define DUMPSTACK /* disabled */
#endif


/**
PERFORMANCE COUNTERS
**/
//#define ENABLE_PERFORMANCE_COUNTERS

#ifdef ENABLE_PERFORMANCE_COUNTERS
    #define ADDPFH(function, timing, args) call { _ret = [function, timing, args] call CBA_fnc_addPerFrameHandler; if (isNil "MAI_PFH" ) then { MAI_PFH=[]; }; MAI_PFH pushBack [[_ret, __FILE__, __LINE__], [function, timing, args]];  _ret }

    #define CREATE_COUNTER(x) if (isNil "MAI_COUNTERS" ) then { MAI_COUNTERS=[]; }; GVAR(DOUBLES(x,counter))=[]; GVAR(DOUBLES(x,counter)) set[0, QGVAR(DOUBLES(x,counter))];  GVAR(DOUBLES(x,counter)) set[1, diag_tickTime]; MAI_COUNTERS pushBack GVAR(DOUBLES(x,counter));
    #define BEGIN_COUNTER(x) if (isNil QGVAR(DOUBLES(x,counter))) then { CREATE_COUNTER(x) }; GVAR(DOUBLES(x,counter)) set[2, diag_tickTime];
    #define END_COUNTER(x) GVAR(DOUBLES(x,counter)) pushBack [(GVAR(DOUBLES(x,counter)) select 2), diag_tickTime];

    #define DUMP_COUNTERS ([__FILE__, __LINE__] call MAI_DUMPCOUNTERS_FNC)
#else
    #define ADDPFH(function, timing, args) [function, timing, args] call CBA_fnc_addPerFrameHandler

    #define CREATE_COUNTER(x) /* disabled */
    #define BEGIN_COUNTER(x) /* disabled */
    #define END_COUNTER(x) /* disabled */
    #define DUMP_COUNTERS  /* disabled */
#endif
