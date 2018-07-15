class MAI_Caching_StateMachine {
    list = QUOTE(allGroups select {local _x && _x getVariable [ARR_2(QQEGVAR(core,enabled), false)]});
    skipNull = 1;

    class Init {
        onStateEntered = QFUNC(onInitStateEntered);
        class Cache {
            targetState = "Cache";
            condition = QFUNC(shouldCache);
        };
    };

    class Cache {
        onStateEntered = QFUNC(cacheGroup);
        class LeaderChanged {
            targetState = "LeaderChanged";
            condition = QUOTE(leader _this != (_this getVariable QQGVAR(leader)));
        };

        class Uncache {
            targetState = "Uncache";
            condition = QUOTE(!([_this] call FUNC(shouldCache)));
        };
    };

    class LeaderChanged {
        onStateEntered = QFUNC(changeLeader);

        class Cache {
            targetState = "Cache";
            events[] = {QGVAR(cache)};
        };
    };

    class Uncache {
        onStateEntered = QFUNC(uncacheGroup);

        class Cache {
            targetState = "Cache";
            condition = QFUNC(shouldCache);
        };
    };
};
