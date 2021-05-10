using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TransitionControl : MonoBehaviour
{
    public float displayDistance;
    public GameObject currentTimeLinePrefab;
    public GameObject pastTimeLinePrefab;
    public List<Material> goodMaterial;
    public List<Material> badMaterials;
    private PlayerState currentPlayerState;
    public bool CanTimeSwap = false;
    public bool Malfunction = false;
    public float transitonSpeed;
    public float transitionLimit;
    public Transform triggerCube;
    public GameObject flashLight;
    [SerializeField]private TextMeshProUGUI uGUI;
    private string tooltip = "";
    public int count = 0;
    public GameObject currentTimelineProp;
    public GameObject pastTimelineProp;
    // Start is called before the first frame update
    void Start()
    {
        //
        foreach (Material a in badMaterials)
        {
            if (a != null)
            {
                a.SetInt("_off",0);
                a.SetFloat("_edgewidth", 1);
                a.SetFloat("_reverse",-1);
                a.SetFloat("_Cutoff",0);
                //a.SetFloat("edgeWidth");
            }
            
        }
        foreach (Material a in goodMaterial)
        {
            if (a != null)
            {
                a.SetInt("_off", 0);
                a.SetFloat("_edgewidth", 1);
                a.SetFloat("_reverse", 1);
                a.SetFloat("_Cutoff", 0);
                //a.SetFloat("edgeWidth");
            }

        }

        ChangeState(new Current(this));
        //currentTimeLinePrefab.transform.position = new Vector3(0,0,0);
    }

    // Update is called once per frame
    void Update()
    {

        currentPlayerState.stateBehavior();
        Debug.Log(Vector3.Distance(transform.position, triggerCube.position));
        if (Vector3.Distance(transform.position,triggerCube.position) < 20 && count == 4 && currentPlayerState.ToString().Equals("Past"))
        {
            Malfunction = true;
        }
        uGUI.text = "shards collected " + count.ToString() + "/4" + tooltip;
        foreach (Material a in badMaterials)
        {
            if (a != null)
            {
                a.SetFloat("_distance",displayDistance);
            }

        }
        foreach (Material a in goodMaterial)
        {
            if (a != null)
            {
                a.SetFloat("_distance", displayDistance);
            }

        }

        if (Input.GetKey(KeyCode.C))
        {
            displayDistance += 4 * Time.deltaTime;
        }
        else if (Input.GetKey(KeyCode.Z))
        {
            displayDistance -= 4 * Time.deltaTime;
        }
        if (Input.GetKeyDown(KeyCode.X))
        {
            foreach (Material a in badMaterials)
            {
                if (a != null)
                {
                    a.SetInt("_off", 1);
                }

            }
            foreach (Material a in goodMaterial)
            {
                if (a != null)
                {
                    a.SetInt("_off", 1);
                }

            }
        }
    }


   /*
    void OnControllerColliderHit(ControllerColliderHit hit)
    {
        GameObject a = hit.gameObject;
        if (a.CompareTag("Shards"))
        {
            if (a.name.Equals("TimeDevice"))
            {
                CanTimeSwap = true;
                tooltip = "\npress Q to switch timeline";
            }
            else
            {
                
            }
            
            Debug.Log("collect");
            
            Destroy(a);
        }
    }
    */
    public void PickUpShard(GameObject a)
    {
        count++;
        //play audio
        Destroy(a);
    }

    public void PickUpTimeDevice(GameObject a)
    {
        CanTimeSwap = true;
        tooltip = "\npress Q to switch timeline";
        Destroy(a);
    }
    public void ChangeState(PlayerState newPlayerState)
    {
        if (currentPlayerState != null) currentPlayerState.Leave();
        currentPlayerState = newPlayerState;
        currentPlayerState.Enter();
    }
}
