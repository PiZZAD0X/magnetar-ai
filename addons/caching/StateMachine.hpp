class MAI_Caching_StateMachine {
    list = QUOTE(allGroups select {local _x && _x getVariable [ARR_2(QQEGVAR(core,enabled), false)]});
    skipNull = 1;

    class Init {
        onStateEntered = QFUNC(onInitStateEntered);
        class Cache {
            targetState = "Cache";
            condition = QUOTE(CBA_missionTime > 0);
        };
    };

    class Cache {
        class LeaderChanged {
            targetState = "LeaderChanged";
            condition = QUOTE(CBA_missionTime > 0);
        };
        class Uncache {
            targetState = "Uncache";
            events[] = {QGVAR(Uncache)};
        };
    };

    class LeaderChanged {
        onStateEntered = QFUNC(changeLeader);
        class Running {
            targetState = "Running";
            events[] = {QGVAR(running)};
        };
    };

    class Uncache {
        onStateEntered = QFUNC(onPatrolRandomStateEntered);
        onState = QFUNC(handlePatrolRandomState);

        class Cache {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
        };
    };
};
