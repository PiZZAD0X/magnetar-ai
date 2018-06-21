class CfgGroupCompositions {
    class Common {
        behaviour[] = ["careless", "safe", "aware", "combat", "stealth"];
        combatMode[] = ["blue", "green", "white", "yellow", "red"];
        formation[] = ["column", "stag column", "wedge", "ech left", "ech right", "vee", "line", "file", "diamond"];
        speed[] = ["limited", "normal", "full"];
        skill[] = [[0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8]];
        skillLeader[] = [[0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8], [0.2, 0.8]];
        execInit = "";
        execWaypoint = "";
        task[] = ["patrol"];
    };
    class rhs_usaf_marine : Common {
        type = "infantry";
        side = "west";
        leaders[] = [];
        units[] = [];
        options[] = [["allowWater", false], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", true]];
    };
    class Wheeled : Common {
        type = "wheeled";
        vehicles[] = [];
        side = "west";
        crew[] = [];
        cargoLeaders[] = [];
        cargo[] = [];
        options[] = [["allowWater", false], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", true]];
    };
    class Armored : Wheeled {
        type = "armored";
        vehicles[] = [];
        crew[] = [];
        options[] = [["allowWater", false], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", false]];
    };
    class Air : Wheeled {
        type = "air";
        vehicles[] = [];
        crew[] = [];
        pilot[] = [];
        options[] = [["allowWater", true], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", false]];
    };
    class Boat : Wheeled {
        type =  "boat";
        vehicles[] = [];
        crew[] = [];
        cargoLeaders[] = [];
        cargo[] = [];
        options[] = [["allowWater", true], ["forceRoads", false], ["randomBehaviour", true], ["waitAtWaypoint", true], ["allowVehicles", false], ["patrolBuildings", false]];
    };
};
