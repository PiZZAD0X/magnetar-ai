class MAI_Tasks_StateMachine {
    list = QUOTE(allGroups select {local _x && _x getVariable [ARR_2(QQEGVAR(core,enabled), false)]});
    skipNull = 1;

    class Init {
        onStateEntered = QUOTE(DFUNC(onInitStateEntered));
        class DoTask {
            targetState = "DoTask";
            condition = QUOTE(CBA_missionTime > 0);
        };
    };

    class DoTask {
        onStateEntered = QUOTE(DFUNC(onWaypointStateEntered));
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
        };
        class TaskTransport {
            targetState = "TaskTransport";
            events[] = {QGVAR(transport)};
        };
    };

    class TaskPatrol {
        onStateEntered = QUOTE(DFUNC(onPatrolStateEntered));
        onState = QUOTE(DFUNC(handlePatrolState));

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

    class PatrolBuildings {
        onStateEntered = QUOTE(DEFUNC(building,onStateEntered));
        onState = QUOTE(DEFUNC(building,handlePatrolBuilding));

        class DoTask {
            targetState = "DoTask";
            events[] = {QGVAR(doTask)};
        };
    };

    class SearchVehicles {

    };

    class PatrolPerimeter {
        onStateEntered = QUOTE(DFUNC(onPatrolPerimeterEntered));

        class PatrolBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
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

    class Disembark {
        onStateEntered = QUOTE(DEFUNC(vehicle,disembark));
        onState = QUOTE(DEFUNC(vehicle,handleDisembark));

        class PatrolBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
        };

        class PatrolPerimeter {
            targetState = "PatrolPerimeter";
            events[] = {QGVAR(PatrolPerimeter)};
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
        onStateEntered = QUOTE(DFUNC(onEmbarkStateEntered));
        onState = QUOTE(DFUNC(handleEmbark));
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
