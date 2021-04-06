using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyList : MonoBehaviour
{
    public List<GameObject> allEnemy;

    //Segments for how detailed a circle the Line Renderer will draw
    [Range(0, 50)]
    public int segments = 50;
    //Radius
    [Range(0, 5)]
    public float xradius = 5;
    [Range(0, 5)]
    public float yradius = 5;
    [Range(0, 360)]
    public float maxAngle = 360;
    //LineRenderer line;

    // Start is called before the first frame update
    void Start()
    {
        drawCircles();
        //releaseTheKraken();
        cellTheKraken();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void drawCircles()
    {
        foreach (var i in allEnemy)
        {
            LineRenderer tmp = i.AddComponent<LineRenderer>();
            xradius = i.GetComponent<Detection>().maxRadius;
            yradius = xradius;
            tmp.startWidth = .1f;
            tmp.endWidth = .1f;

            tmp.positionCount = segments + 1;
            tmp.useWorldSpace = false;
            createCircle(tmp);
        }
    }

    void createCircle(LineRenderer line)
    {
        float x;
        float y;
        float z;

        float angle = 0f;

        for (int i = 0; i <= segments + 1; i++)
        {
            x = Mathf.Sin(Mathf.Deg2Rad * angle) * xradius;
            y = 0;
            z = Mathf.Cos(Mathf.Deg2Rad * angle) * yradius;
           // line.SetPosition(i, new Vector3(x, y, z));

            angle += (360f / segments);
        }
    }

    public void releaseTheKraken()
    {
        foreach (var i in allEnemy)
        {
            i.SetActive(true);
            i.GetComponent<EnemyScript>().StartMoving(i.GetComponent<EnemyScript>().wayPoints);
        }
    }

    public void cellTheKraken()
    {
        foreach (var i in allEnemy)
        {
            i.SetActive(false);
        }
    }
}
