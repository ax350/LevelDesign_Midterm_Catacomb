﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Detection : MonoBehaviour
{
    public Transform player;
    public GameObject playerObject;
    public float maxAngle;
    public float maxRadius;

    private static MeshRenderer enemyRenderer;
    private static int nameID;
    
    private bool isInFov = false;

    void Start()
    {
        enemyRenderer = this.GetComponent<MeshRenderer>();
        nameID = Shader.PropertyToID("_Color");
        Debug.Log(nameID);
    }


    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, maxRadius);

        Vector3 fovLine1 = Quaternion.AngleAxis(maxAngle, transform.up) * transform.forward * maxRadius;
        Vector3 fovLine2 = Quaternion.AngleAxis(-maxAngle, transform.up) * transform.forward * maxRadius;

        Gizmos.color = Color.blue;
        Gizmos.DrawRay(transform.position, fovLine1);
        Gizmos.DrawRay(transform.position, fovLine2);

        if (!isInFov)
        {
            Gizmos.color = Color.red;
        }
        else
        {
            Gizmos.color = Color.green;
        }

        Gizmos.DrawRay(transform.position, (player.position - transform.position).normalized * maxRadius);

        Gizmos.color = Color.black;
        Gizmos.DrawRay(transform.position, transform.forward * maxRadius);


    }

    public bool inFOV(Transform checkingObject, Transform target, float maxAngle, float maxRadius, GameObject playerObject)
    {
        Collider[] overlaps = new Collider[10];
        int count = Physics.OverlapSphereNonAlloc(checkingObject.position, maxRadius, overlaps);

        for (int i = 0; i < count + 1; i++)
        {
            if (overlaps[i] != null)
            {
                if (overlaps[i].transform == target)
                {

                    Vector3 directionBetween = (target.position - checkingObject.position).normalized;
                    directionBetween.y *= 0;

                    float angle = Vector3.Angle(checkingObject.forward, directionBetween);

                    if (angle <= maxAngle)
                    {
                        Ray ray = new Ray(checkingObject.position, target.position - checkingObject.position);
                        RaycastHit hit;

                        if (Physics.Raycast(ray, out hit, maxRadius))
                        {
                            if (hit.transform == target)
                            {
                                
                                //enemyRenderer.material.color = Color.red;
                                //enemyRenderer.enabled = false;
                                SceneManager.LoadScene(0);
                                //playerObject.GetComponent<PlayerMoveOriginal>().hardwire();
                                //Debug.Log("Found Player");
                                return true;
                            }

                        }
                    }
                }
            }

        }
        return false;

    }

    // Update is called once per frame
    private void Update()
    {
        isInFov = inFOV(transform, player, maxAngle, maxRadius, playerObject);
    }
}
