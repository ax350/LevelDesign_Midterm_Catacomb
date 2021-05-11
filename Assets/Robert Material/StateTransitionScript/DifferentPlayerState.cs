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

        if (Input.GetKeyDown(KeyCode.Q) && playerStateManager.TimeDeviceCharge > 5)
        {
            if (playerStateManager.CanTimeSwap)
            {
                playerStateManager.ChangeState(new CurrentToPast(playerStateManager));
            }
            
        }

        playerStateManager.TimeDeviceCharge += playerStateManager.TimeDeviceRechargeSpeed * Time.deltaTime;
        playerStateManager.TimeDeviceCharge = Mathf.Min(playerStateManager.TimeDeviceChargeMax,playerStateManager.TimeDeviceCharge);
    }

    public override void Enter()
    {
        base.Enter();
        playerStateManager.flashLight.SetActive(true);
        //set all current prop active
        playerStateManager.currentTimelineProp.SetActive(true);
        playerStateManager.currentTimeLinePrefab.SetActive(true);
        playerStateManager.pastTimeLinePrefab.SetActive(false);
        playerStateManager.displayDistance = -5;
    }

    public override void Leave()
    {
        base.Leave();
        playerStateManager.flashLight.SetActive(false);
        playerStateManager.currentTimelineProp.SetActive(false);
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
        playerStateManager.TimeDevice.SetBool("open", true);
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
        if (Input.GetKeyDown(KeyCode.Q) || playerStateManager.TimeDeviceCharge <= 0)
        {
            if (playerStateManager.Malfunction)
            {
                playerStateManager.TimeDeviceCharge = 99;
                playerStateManager.ChangeState(new PastToPast(playerStateManager));
            }
            else if (playerStateManager.CanTimeSwap)
            {
                playerStateManager.ChangeState( new PastToCurrent(playerStateManager));
            }

        }
        playerStateManager.TimeDevice.SetFloat("speed", playerStateManager.Remap(playerStateManager.TimeDeviceCharge, 0, playerStateManager.TimeDeviceChargeMax, 0.1f, 1.2f));
        playerStateManager.TimeDeviceCharge -= Time.deltaTime;
        playerStateManager.TimeDeviceCharge = Mathf.Max(0, playerStateManager.TimeDeviceCharge);

    }

    public override void Enter()
    {
        base.Enter();
        playerStateManager.pastTimelineProp.SetActive(true);
        playerStateManager.displayDistance = playerStateManager.transitionLimit;
        playerStateManager.pastTimeLinePrefab.SetActive(true);
        playerStateManager.currentTimeLinePrefab.SetActive(false);
    }

    public override void Leave()
    {

        base.Leave();
        playerStateManager.TimeDevice.SetFloat("speed",1);
        playerStateManager.pastTimelineProp.SetActive(false);
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
        playerStateManager.TimeDevice.SetBool("open", false);
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

