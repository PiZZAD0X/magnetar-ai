class MAI_Tasks_StateMachine {
    list = QUOTE(allGroups select {local _x && _x getVariable [ARR_2(QQEGVAR(core,maiEnabled), false)]});
    skipNull = 1;

    class Init {
        onStateEntered = QFUNC(onInitStateEntered);
    };
    
    class GenerateWaypoint {
        onStateEntered = QFUNC(onWaypointStateEntered);
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
            events[] = {QGVAR(taskTransport)}:
        }
    };

    class TaskPatrol {
        onState = QFUNC(handlePatrolState);
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
    };
    
    class PatrolBuildings {

    };
    class SearchVehicles {

    };
    class SearchZone {

    };
    class Wait {
        onStateEntered = QUOTE(_this setVariable [ARR_2(QGVAR(waitUntil), CBA_missionTime + 30 + random 30)]); // killing a ; // killing a unit also exits the state machine for this unit

        class GenerateWaypoint {
            targetState = "GenerateWaypoint";
            condition = {CBA_missionTime >= _this getVariable [QGVAR(waitUntil), CBA_missionTime]};
            events[] = {QGVAR(GenerateWaypoint)};
        };
    };
};
