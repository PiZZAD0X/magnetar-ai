class CfgGroupCompositions {
    class Common {
        behaviour[] = ["careless", "safe", "aware", "combat", "stealth"];
        combatMode[] = ["blue", "green", "white", "yellow", "red"];
        formation[] = ["column", "stag column", "wedge", "ech left", "ech right", "vee", "line", "file", "diamond"];
        speed[] = ["limited", "normal", "full"];
        skill[] = [[0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8]];
        skillLeader = [[0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8]];
        execInit = "";
        execWaypoint = "";
    };
    class rhs_usaf_marine : Common {
        type = "infantry";
        side = "west";
        leader[] = [];
        units[] = [];
        waypointOptions = [["allowWater", false], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", true]];
    };
    class Wheeled : Common {
        type = "wheeled";
        leader[] =
        vehicles[] =
        side = "west";
        crew[] = [];
        cargoLeader[] = [];
        cargo[] = [];
        waypointOptions = [["allowWater", false], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", true]];
    };
    class Armored : Wheeled {
        type = "armored";
        leader[] = [];
        vehicles[] = [];
        crew[] = [];
        waypointOptions = [["allowWater", false], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", false]];
    };
    class Air : Wheeled {
        type = "air";
        leader[] = [];
        vehicles[] = [];
        crew[] = [];
        waypointOptions = [["allowWater", true], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", false]];
    };
    class Boat : Wheeled {
        type =  "boat";
        leader[] = [];
        vehicles[] = [];
        crew[] = [];
        cargoLeader[] = [];
        cargo[] = [];
        waypointOptions = [["allowWater", true], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", false]];
    };
};
