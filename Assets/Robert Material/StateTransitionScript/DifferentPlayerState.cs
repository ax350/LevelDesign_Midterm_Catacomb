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
            if (playerStateManager.CanTimeSwap)
            {
                playerStateManager.ChangeState(new CurrentToPast(playerStateManager));
            }
            
        }

    }

    public override void Enter()
    {
        base.Enter();

        playerStateManager.currentTimeLinePrefab.SetActive(true);
        playerStateManager.pastTimeLinePrefab.SetActive(false);
        playerStateManager.displayDistance = -5;
    }

    public override void Leave()
    {
        base.Leave();

    }
}

public class CurrentToPast : PlayerState
{
    float distance = -1;
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
        distance += Time.deltaTime * playerStateManager.transitonSpeed;
    }

    public override void Enter()
    {
        base.Enter();
        foreach (Material a in playerStateManager.badMaterials)
        {
            if (a != null)
            {
                a.SetInt("_off", 0);
                
            }

        }
        foreach (Material a in playerStateManager.goodMaterial)
        {
            if (a != null)
            {
                a.SetInt("_off", 0);
                

            }

        }
        playerStateManager.pastTimeLinePrefab.SetActive(true);
        playerStateManager.currentTimeLinePrefab.SetActive(true);
        playerStateManager.displayDistance = -1;
    }

    public override void Leave()
    {
        base.Leave();
        foreach (Material a in playerStateManager.badMaterials)
        {
            if (a != null)
            {
                a.SetInt("_off", 1);
                a.SetFloat("_reverse", 1);
            }

        }
        foreach (Material a in playerStateManager.goodMaterial)
        {
            if (a != null)
            {
                a.SetInt("_off", 1);
                a.SetFloat("_reverse", -1);
            }

        }

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
            if (playerStateManager.Malfunction)
            {
                playerStateManager.ChangeState(new PastToPast(playerStateManager));
            }
            else if (playerStateManager.CanTimeSwap)
            {
                playerStateManager.ChangeState( new PastToCurrent(playerStateManager));
            }

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

public class PastToPast : PlayerState
{
    float distance = -1;
    bool goingUp = true;
    public PastToPast(TransitionControl theGameStateManager) : base(theGameStateManager)
    {

    }

    public override void stateBehavior()
    {
        /*
        playerStateManager.displayDistance = distance;

        if (distance <= -1)
        {
            playerStateManager.ChangeState(new Current(playerStateManager));
        }
        distance -= Time.deltaTime * playerStateManager.transitonSpeed;
        */

        playerStateManager.displayDistance = distance;
        if (goingUp)
        {
            distance += Time.deltaTime * playerStateManager.transitonSpeed/5;
            if (distance >= 15)
            {
                goingUp = false;
            }
        }
        else if (!goingUp)
        {
            distance -= Time.deltaTime * playerStateManager.transitonSpeed/5;
            if (distance <= 0)
            {
                playerStateManager.ChangeState(new Past(playerStateManager));
            }
        }

        
        

    }

    public override void Enter()
    {
        base.Enter();
        foreach (Material a in playerStateManager.badMaterials)
        {
            if (a != null)
            {
                a.SetInt("_off", 0);

            }

        }
        foreach (Material a in playerStateManager.goodMaterial)
        {
            if (a != null)
            {
                a.SetInt("_off", 0);

            }

        }
        playerStateManager.pastTimeLinePrefab.SetActive(true);
        playerStateManager.currentTimeLinePrefab.SetActive(true);
        //distance = playerStateManager.displayDistance;
    }

    public override void Leave()
    {
        base.Leave();
        foreach (Material a in playerStateManager.badMaterials)
        {
            if (a != null)
            {
                a.SetInt("_off", 1);
                
            }

        }
        foreach (Material a in playerStateManager.goodMaterial)
        {
            if (a != null)
            {
                a.SetInt("_off", 1);
                
            }

        }
        playerStateManager.displayDistance = -1;
    }
}

public class PastToCurrent : PlayerState
{
    float distance = -1;
    public PastToCurrent(TransitionControl theGameStateManager) : base(theGameStateManager)
    {

    }

    public override void stateBehavior()
    {
        /*
        playerStateManager.displayDistance = distance;

        if (distance <= -1)
        {
            playerStateManager.ChangeState(new Current(playerStateManager));
        }
        distance -= Time.deltaTime * playerStateManager.transitonSpeed;
        */

        playerStateManager.displayDistance = distance;

        if (distance >= playerStateManager.transitionLimit)
        {
            playerStateManager.ChangeState(new Current(playerStateManager));
        }
        distance += Time.deltaTime * playerStateManager.transitonSpeed;

    }

    public override void Enter()
    {
        base.Enter();
        foreach (Material a in playerStateManager.badMaterials)
        {
            if (a != null)
            {
                a.SetInt("_off", 0);

            }

        }
        foreach (Material a in playerStateManager.goodMaterial)
        {
            if (a != null)
            {
                a.SetInt("_off", 0);

            }

        }
        playerStateManager.pastTimeLinePrefab.SetActive(true);
        playerStateManager.currentTimeLinePrefab.SetActive(true);
        //distance = playerStateManager.displayDistance;
    }

    public override void Leave()
    {
        base.Leave();
        foreach (Material a in playerStateManager.badMaterials)
        {
            if (a != null)
            {
                a.SetInt("_off", 1);
                a.SetFloat("_reverse", -1);
            }

        }
        foreach (Material a in playerStateManager.goodMaterial)
        {
            if (a != null)
            {
                a.SetInt("_off", 1);
                a.SetFloat("_reverse", 1);
            }

        }
        playerStateManager.displayDistance = -1;
    }
}

