using UnityEngine;

namespace DestroyableTerrain
{
    public class DestoryableTerrain : MonoBehaviour
    {
        public void DestroyThisTerrain()
        {
            Destroy(gameObject);
        }
    }
}