using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class RayCastCamera : MonoBehaviour
{
    public float castingDistance = 4;
    RaycastHit objectHit;
    private int interactableLayer;
    public GameObject uiText;
    public TextMeshProUGUI uiTextContent;
    public TransitionControl transitionControl;

    // Start is called before the first frame update
    void Start()
    {
        interactableLayer = LayerMask.GetMask("InteractableObject");
    }

    // Update is called once per frame
    [System.Obsolete]
    void Update()
    {
        Ray myRay = new Ray(transform.position, transform.forward);

        Debug.DrawRay(myRay.origin, myRay.direction * castingDistance, Color.magenta);

        if (Physics.Raycast(myRay, out objectHit, castingDistance, interactableLayer))
        {
            uiText.SetActive(true);

            if (objectHit.collider.gameObject.name.Equals("TimeDevice"))
            {
                uiTextContent.text = "pick up this";
                if (Input.GetMouseButtonDown(0))
                {
                    transitionControl.PickUpTimeDevice(objectHit.collider.gameObject);
                }
            }
            else if (objectHit.collider.gameObject.CompareTag("Shards"))
            {
                uiTextContent.text = "pick up shard";
                if (Input.GetMouseButtonDown(0))
                {
                    transitionControl.PickUpShard(objectHit.collider.gameObject);
                }
            }





        }
        else
        {
            uiText.SetActive(false);
        }
    }
}