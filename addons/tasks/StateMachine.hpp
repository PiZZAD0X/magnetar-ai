class MAI_Tasks_StateMachine {
    list = QUOTE(allGroups select {local _x && _x getVariable [ARR_2(QQEGVAR(core,enabled), false)]});
    skipNull = 1;

    class Init {
        onStateEntered = QUOTE(DFUNC(onInitStateEntered));
        class GenerateWaypoint {
            targetState = "GenerateWaypoint";
            condition = QUOTE(systemchat format ['waypoint']; CBA_missionTime > 0);
            events[] = {QGVAR(generateWaypoint)};
        };
    };

    class GenerateWaypoint {
        onStateEntered = QUOTE(DFUNC(onWaypointStateEntered));
        class TaskAttack {
            targetState = "TaskAttack";
            events[] = {QGVAR(taskAttack)};
        };
        class TaskDefend {
            targetState = "TaskDefend";
            events[] = {QGVAR(taskDefend)};
        };
        class TaskGarrisson {
            targetState = "TaskGarrisson";
            events[] = {QGVAR(taskGarrisson)};
        };
        class TaskPatrol {
            targetState = "TaskPatrol";
            events[] = {QGVAR(taskPatrol)};
        };
        class TaskTransport {
            targetState = "TaskTransport";
            events[] = {QGVAR(taskTransport)};
        };
    };

    class TaskPatrol {
        onState = QUOTE(DFUNC(handlePatrolState));
        onStateEntered = "systemChat format ['entered patrol task'];";
        class PatrolBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
        };
        class PatrolZone {
            targetState = "PatrolZone";
            events[] = {QGVAR(patrolZone)};
        };
        class SearchVehicles {
            targetState = "SearchVehciles";
            events[] = {QGVAR(searchVehicles)};
        };
        class Wait {
            targetState = "Wait";
            events[] = {QGVAR(wait)};
        };
    };

    class PatrolBuildings {
        onStateEntered = QUOTE(DEFUNC(building,onStateEntered));
        onState = QUOTE(DEFUNC(building,handlePatrolBuilding));

        class TaskAttack {
            targetState = "TaskAttack";
            events[] = {QGVAR(taskAttack)};
        };
        class TaskDefend {
            targetState = "TaskDefend";
            events[] = {QGVAR(taskDefend)};
        };
        class TaskGarrisson {
            targetState = "TaskGarrisson";
            events[] = {QGVAR(taskGarrisson)};
        };
        class TaskPatrol {
            targetState = "TaskPatrol";
            events[] = {QGVAR(taskPatrol)};
        };
        class TaskTransport {
            targetState = "TaskTransport";
            events[] = {QGVAR(taskTransport)};
        };
    };

    class SearchVehicles {

    };
    class SearchZone {

    };

    class Wait {
        onStateEntered = QUOTE(_this setVariable [ARR_2(QQGVAR(waitUntil), CBA_missionTime + 30 + random 30)]); // killing a ; // killing a unit also exits the state machine for this unit

        class GenerateWaypoint {
            targetState = "GenerateWaypoint";
            condition = QUOTE(CBA_missionTime >= _this getVariable [ARR_2(QQGVAR(waitUntil), CBA_missionTime)]);
            events[] = {QGVAR(generateWaypoint)};
        };
    };
};
