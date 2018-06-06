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
        leader[] = [];
        units[] = [];
        waypointRestrictions[] = {"noWater"};
    };
    class Wheeled : Common {
        type = "wheeled";
        leader[] =
        vehicles[] =
        crew[] =
        infantryLeader[] = [];
        infantry[] = [];
        waypointRestrictions[] = {"noWater"};
    };
    class Armored : Wheeled {
        type = "armored";
    };
    class Air : Wheeled {
        type = "air";
        waypointRestrictions[] = {"noLandWater"};
    };
    class Boat : Wheeled {
        type =  "boat";
        waypointRestrictions[] = {"noLand"};
    };
};
