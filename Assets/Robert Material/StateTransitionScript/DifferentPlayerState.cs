using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DifferentPlayerState : MonoBehaviour
{

}

public class Current: PlayerState
{
    public Current(TransitionControl theGameStateManager) : base(theGameStateManager)
    {

    }

    public override void stateBehavior()
    {

        if (Input.GetKeyDown(KeyCode.Q))
        {
            playerStateManager.ChangeState(new CurrentToPast(playerStateManager));
        }

    }

    public override void Enter()
    {
        base.Enter();
        playerStateManager.currentTimeLinePrefab.SetActive(true);
        playerStateManager.pastTimeLinePrefab.SetActive(false);
        playerStateManager.displayDistance = 0;
    }

    public override void Leave()
    {
        base.Leave();
    }
}

public class CurrentToPast : PlayerState
{
    float distance = 0;
    public CurrentToPast(TransitionControl theGameStateManager) : base(theGameStateManager)
    {

    }

    public override void stateBehavior()
    {
        playerStateManager.displayDistance = distance;
        
        if (distance >= playerStateManager.transitionLimit)
        {
            playerStateManager.ChangeState(new Past(playerStateManager));
        }
        distance += Time.deltaTime*playerStateManager.transitonSpeed;
    }

    public override void Enter()
    {
        base.Enter();
        playerStateManager.pastTimeLinePrefab.SetActive(true);
        playerStateManager.currentTimeLinePrefab.SetActive(true);
    }

    public override void Leave()
    {
        base.Leave();
    }
}

public class Past : PlayerState
{
    public Past(TransitionControl theGameStateManager) : base(theGameStateManager)
    {

    }

    public override void stateBehavior()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            playerStateManager.ChangeState(new PastToCurrent(playerStateManager));
        }


    }

    public override void Enter()
    {
        base.Enter();
        playerStateManager.displayDistance = playerStateManager.transitionLimit;
        playerStateManager.pastTimeLinePrefab.SetActive(true);
        playerStateManager.currentTimeLinePrefab.SetActive(false);
    }

    public override void Leave()
    {
        base.Leave();
    }
}

public class PastToCurrent : PlayerState
{
    float distance = 0;
    public PastToCurrent(TransitionControl theGameStateManager) : base(theGameStateManager)
    {

    }

    public override void stateBehavior()
    {
        playerStateManager.displayDistance = distance;

        if (distance <= 0)
        {
            playerStateManager.ChangeState(new Current(playerStateManager));
        }
        distance -= Time.deltaTime * playerStateManager.transitonSpeed;


    }

    public override void Enter()
    {
        base.Enter();
        playerStateManager.pastTimeLinePrefab.SetActive(true);
        playerStateManager.currentTimeLinePrefab.SetActive(true);
        distance = playerStateManager.displayDistance;
    }

    public override void Leave()
    {
        base.Leave();
    }
}

