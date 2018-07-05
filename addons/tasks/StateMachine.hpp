class MAI_Tasks_StateMachine {
    list = QUOTE(allGroups select {local _x && _x getVariable [ARR_2(QQEGVAR(core,enabled), false)]});
    skipNull = 1;

    class Init {
        onStateEntered = QFUNC(onInitStateEntered);
        class DoTask {
            targetState = "DoTask";
            condition = QUOTE(CBA_missionTime > 0);
        };
    };

    class DoTask {
        onStateEntered = QFUNC(onDoTaskStateEntered);
        class TaskAttack {
            targetState = "TaskAttack";
            events[] = {QGVAR(attack)};
        };
        class TaskDefend {
            targetState = "TaskDefend";
            events[] = {QGVAR(defend)};
        };
        class TaskGarrisson {
            targetState = "TaskGarrisson";
            events[] = {QGVAR(garrisson)};
        };
        class TaskPatrol {
            targetState = "TaskPatrol";
            events[] = {QGVAR(patrol)};
        }
        class TaskPatrolRandom {
            targetState = "TaskPatrolRandom";
            events[] = {QGVAR(patrolRandom)};
        };
        class TaskTransport {
            targetState = "TaskTransport";
            events[] = {QGVAR(transport)};
        };
    };

    class TaskPatrolRandom {
        onStateEntered = QFUNC(onPatrolRandomStateEntered);
        onState = QFUNC(handlePatrolRandomState);

        class PatrolBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
        };
        class SearchVehicles {
            targetState = "SearchVehciles";
            events[] = {QGVAR(searchVehicles)};
        };
        class Disembark {
            targetState = "Disembark";
            events[] = {QGVAR(disembark)};
        };
        class Wait {
            targetState = "Wait";
            events[] = {QGVAR(wait)};
        };
    };

    class TaskPatrol {
        onStateEntered = QFUNC(onPatrolEntered);

        class PatrolBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
        };

        class Embark {
            targetState = "Embark";
            events[] = {QGVAR(embark)};
        };

        class Disembark {
            targetState = "Disembark";
            events[] = {QGVAR(disembark)};
        };

        class Wait {
            targetState = "Wait";
            events[] = {QGVAR(wait)};
        };
    };

    class PatrolBuildings {
        onStateEntered = QEFUNC(building,onStateEntered);
        onState = QEFUNC(building,handlePatrolBuilding);

        class DoTask {
            targetState = "DoTask";
            events[] = {QGVAR(doTask)};
        };
    };

    class SearchVehicles {

    };

    class Disembark {
        onStateEntered = QEFUNC(vehicle,disembark);
        onState = QEFUNC(vehicle,handleDisembark);

        class PatrolBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
        };

        class TaskPatrol {
            targetState = "TaskPatrol";
            events[] = {QGVAR(patrol)};
        };

        class Embark {
            targetState = "Embark";
            events[] = {QGVAR(embark)};
        };

        class Wait {
            targetState = "Wait";
            events[] = {QGVAR(wait)};
        };
    };

    class Embark {
        onStateEntered = QFUNC(onEmbarkStateEntered);
        onState = QEFUNC(vehicle,handleEmbark);

        class DoTask {
            targetState = "DoTask";
            events[] = {QGVAR(doTask)};
        };
    };

    class Wait {
        onStateEntered = QUOTE(_this setVariable [ARR_2(QQGVAR(waitUntil), CBA_missionTime + 30 + random 30)]); // killing a ; // killing a unit also exits the state machine for this unit

        class DoTask {
            targetState = "DoTask";
            condition = QUOTE(CBA_missionTime >= _this getVariable [ARR_2(QQGVAR(waitUntil), CBA_missionTime)]);
        };
    };
};
