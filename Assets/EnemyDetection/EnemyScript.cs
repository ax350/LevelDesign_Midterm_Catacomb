using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EnemyScript : MonoBehaviour
{
    public float speed = 5;
    public float waitTime = 0.5f;
    public float turnSpeed = 80;

    public Transform pathHolder;

    //Personal Mod
    //[Range(0, 50)]
    //public int segments = 50;
    //[Range(0, 5)]
    //public float xradius = 5;
    //[Range(0, 5)]
    //public float yradius = 5;
    //LineRenderer line;
    [HideInInspector]
    public Vector3[] wayPoints;

    void Start()
    {
        //line = gameObject.GetComponent<LineRenderer>();

        //line.SetVertexCount(segments + 1);
        //line.useWorldSpace = false;
        //CreatePoints();

        Vector3[] waypoints = new Vector3[pathHolder.childCount];
        wayPoints = waypoints;
        for (int i = 0; i < waypoints.Length; i++)
        {
            waypoints[i] = pathHolder.GetChild(i).position;
            waypoints[i] = new Vector3(waypoints[i].x, transform.position.y, waypoints[i].z);
        }
        StartMoving(waypoints);
    }

    public void StartMoving(Vector3[] waypoints)
    {
        StartCoroutine(FollowPath(waypoints));
    }

    //void CreatePoints()
    //{
    //    float x;
    //    float y;
    //    float z;

    //    float angle = 20f;

    //    for (int i = 0; i < (segments + 1); i++)
    //    {
    //        x = Mathf.Sin(Mathf.Deg2Rad * angle) * xradius;
    //        y = Mathf.Cos(Mathf.Deg2Rad * angle) * yradius;

    //        line.SetPosition(i, new Vector3(x, y, 0));

    //        angle += (360f / segments);
    //    }
    //}

    IEnumerator FollowPath(Vector3[] waypoints)
    {
        transform.position = waypoints[0];

        int targetWaypointIndex = 1;
        Vector3 targetWaypoint = waypoints[targetWaypointIndex];


        while (true)
        {
            transform.position = Vector3.MoveTowards(transform.position, targetWaypoint, speed * Time.deltaTime);
            if (transform.position == targetWaypoint)
            {
                targetWaypointIndex = (targetWaypointIndex + 1) % waypoints.Length;
                targetWaypoint = waypoints[targetWaypointIndex];
                yield return new WaitForSeconds(waitTime);
            }
            yield return null;
        }
    }


    void OnDrawGizmos()
    {
        Vector3 startPosition = pathHolder.GetChild(0).position;
        Vector3 previousPosition = startPosition;

        foreach (Transform waypoint in pathHolder)
        {
            Gizmos.DrawSphere(waypoint.position, .3f);
            Gizmos.DrawLine(previousPosition, waypoint.position);
            previousPosition = waypoint.position;
        }
        Gizmos.DrawLine(previousPosition, startPosition);
    }

}
