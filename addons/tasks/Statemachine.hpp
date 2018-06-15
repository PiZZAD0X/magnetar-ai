class MAI_Tasks_StateMachine {
    list = QUOTE(allGroups select {local _x && _x getVariable [ARR_2(QQEGVAR(core,maiEnabled), false)]});
    skipNull = 1;

    class Init {
        onStateEntered = QFUNC(onInitStateEntered);
    };
    
    class GenerateWaypoint {
        onStateEntered = QFUNC(onWaypointStateEntered);
        class Patrol {
            targetState = "Patrol";
            events[] = {QGVAR(Patrol)};
        };
    };
    class Patrol {
        onState = QFUNC(handlePatrolState);
        onStateEntered = QUOTE([ARR_2(_this,(true))] call EFUNC(medical,setUnconsciousStatemachine));

        class SearchVehicles {
            targetState = "SearchVehciles";
            events[] = {QGVAR(SearchVehicles)};
        };

        class SearchBuildings {
            targetState = "PatrolBuildings";
            events[] = {QGVAR(PatrolBuildings)};
        };
    };
    class SearchVehicles {

    };
    class PatrolBuildings {
        class Patrol {
            targetState = "Patrol";
            events[] = {QGVAR(Patrol)};
        };
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
