---
title: Using MAI with Editor Placed Groups
---

## MAI options

| Option          | Accepted values               | Description |
| --------------- | ----------------------------- | ----------- |
| allowLand       | _true_, false                 |
| allowvehicles   | _true_, false                 |
| allowWater      | true, _false_                 |
| behaviour       | Any valid group behaviour     | Group behaviour. 1)
| combatMode      | Any valid combat mode         | Combat mode. 1)
| execWaypoint    | Any string code (default: "") | Code executed at the end of each waypoint.
| flyInHeight     | Constant value or [min, max]  | Flight altitude.
| forceroads      | true, *false*                 | Forces waypoints on roads.
| formation       | Any valid group formation     | Group formation. 1)
| init            | Any string code (default: "") | Code executed when the group is created.
| marker          | Any valid marker name         | Marker assigned to a group.
| patrolBuildings | _true_, false                 | Group can enter and patrol buildings.
| randomBehaviour | _true_, false                 | Randomise the group's behaviour, combatMode, formation and speed at each waypoint.
| randomPosition  | true, _false_                 | Randomise the position of the group.
| skill           |
| skillLeader     |
| spawnInBuilding | true, _false_                 |
| speed           | Any valid group speed         | Group speed. 1)
| swimInDepth     | Constant value or [min, max]  | Depth the unit will swim at.
| task            | Any valid group task          | Assigned group task. See MAI tasks
| type            | Any valid group type          |
| waitAtWaypoint  | _true_, false                 |
1) If an array is given and randomBehaviour is enabled, a random value will be chosen at the start of each waypoint

## MAI Tasks

- Attack:
- Defend:
- Do Nothing:
- Garrisson:
- Patrol (patrol):
- Random patrol (patrolRandom): _Default behaviour_
- Ressupply:
- Transport:

## MAI Types

- Air:
- Armored:
- Infantry:
- Ship:
- Wheeled:
