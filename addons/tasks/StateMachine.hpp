class MAI_Tasks_StateMachine {
    list = QUOTE(allGroups select {local _x && _x getVariable [ARR_2(QQEGVAR(core,enabled), false)]});
    skipNull = 1;

    class Init {
        onStateEntered = QUOTE(DFUNC(onInitStateEntered));
        class GenerateWaypoint {
            targetState = "GenerateWaypoint";
            condition = QUOTE(CBA_missionTime > 0);
        };
    };

    class GenerateWaypoint {
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
        onStateEntered = "systemChat format ['entered patrol task'];";
        onState = QUOTE(DFUNC(handlePatrolState));
        class PatrolBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
        };
        class SearchZone {
            targetState = "SearchZone";
            events[] = {QGVAR(searchZone)};
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

    class SearchVehicles {

    };
    class SearchZone {

    };

    class Disembark {
        onStateEntered = QUOTE(DEFUNC(vehicle,disembark));
        onState = QUOTE(DEFUNC(vehicle,handleDisembark));

        class PatrolBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(patrolBuildings)};
        };

        class SearchZone {
            targetState = "SearchZone";
            events[] = {QGVAR(searchZone)};
        };

        class Emark {
            targetState = "Embark";
            events[] = {QEGVAR(vehicle,embark)}
        }

        class Wait {
            targetState = "Wait";
            events[] = {QGVAR(wait)};
        };
    };

    class Embark {
        onStateEntered = QUOTE(DEFUNC(vehicle,getInVehicle));

        class class GenerateWaypoint {
            targetState = "GenerateWaypoint";
            events[] = {QGVAR(generateWaypoint)};
        };
    };

    class Wait {
        onStateEntered = QUOTE(_this setVariable [ARR_2(QQGVAR(waitUntil), CBA_missionTime + 30 + random 30)]); // killing a ; // killing a unit also exits the state machine for this unit

        class GenerateWaypoint {
            targetState = "GenerateWaypoint";
            condition = QUOTE(CBA_missionTime >= _this getVariable [ARR_2(QQGVAR(waitUntil), CBA_missionTime)]);
        };
    };
};
