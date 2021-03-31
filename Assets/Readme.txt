DestroyableTerrain user guide;

1. Attach the TerrainTriggerActor script to your actor.
2. Attach the DestroyTerrainTrigger script to a trigger.
3. Attach the DestroyableTerrain script to the terrain you want to destroy when player enter the trigger.

There are 4 types of trigger time to detroy the terrain:
1.  OnEnter
    When actor enters the trigger, the terrain would be destroyed.
2. AfterStayForAWhile
    When actor stays in trigger for a while, the terrain would be destroyed.
3. OnStayAndPressInteractKey
    When actor stays in trigger and press an interactive key, the terrain would be destroyed.
4. OnExit
    When actor exit the trigger, the terrain would be destroyed. 
