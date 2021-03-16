using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IndividualSituations : MonoBehaviour
{
    public LockScript lockScript;
    public DestroyableTerrain.DestroyTerrainTrigger DestroyTerrainTrigger;
    public List<GameObject> gameObjects;
    public EnemyList EnemyList;
    public enum situations
    { 
        OnlyLocks,
        OnlyDestroyables,
        Mixed
    }
    public situations currentSituation;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void enableLockScript(List<GameObject> gameObjects)
    {
        foreach (GameObject gameObject in gameObjects)
        {
            lockScript = gameObject.GetComponent<LockScript>();
            lockScript.enabled = true;
        }
    }

    private void OnDisable()
    {
        //enabledLockScript()
        EnemyList.releaseTheKraken();
        foreach (var i in gameObjects)
        {
            i.SetActive(false);
        }
    }
}
