using System.Collections;
using UnityEngine;

namespace DestroyableTerrain
{
    public class DestroyTerrainTrigger : MonoBehaviour
    {
        [SerializeField]
        private DestoryableTerrain m_DestroyableTerrain; // Should be assigned in the inspector

        public DestroyTime m_DestroyTime;

        public enum DestroyTime
        {
            /// <summary>
            /// When actor enters the trigger, the terrain would be destroyed.
            /// </summary>
            OnEnter,

            /// <summary>
            ///  When actor stays in trigger for a while, the terrain would be destroyed.
            /// </summary>
            AfterStayForAWhile,

            /// <summary>
            /// When actor stays in trigger and press an interactive key, the terrain would be destroyed.
            /// </summary>
            OnStayAndPressInteractKey,

            /// <summary>
            /// When actor exit the trigger, the terrain would be destroyed. 
            /// </summary>
            OnExit,
        }

        [SerializeField]
        private float StayDuration = 2f; // Only for m_DestroyTime == AfterStayForAWhile

        [SerializeField]
        private KeyCode InteractKey = KeyCode.None; // Only for m_DestroyTime == OnStayAndPressInteractKey

        void OnTriggerEnter(Collider colllider)
        {
            if (m_DestroyableTerrain == null) return;
            durationTick = 0f;
            if (m_DestroyTime == DestroyTime.OnEnter)
            {
                if (colllider.GetComponentInParent<TerrainTriggerActor>() != null)
                {
                    DestroyTerrain();
                }
            }
        }

        private float durationTick = 0;

        void OnTriggerStay(Collider collider)
        {
            if (m_DestroyableTerrain == null) return;
            if (collider.GetComponentInParent<TerrainTriggerActor>() != null)
            {
                switch (m_DestroyTime)
                {
                    case DestroyTime.AfterStayForAWhile:
                    {
                        durationTick += Time.fixedDeltaTime;
                        if (durationTick > StayDuration)
                        {
                            durationTick = 0;
                            DestroyTerrain();
                        }

                        break;
                    }
                    case DestroyTime.OnStayAndPressInteractKey:
                    {
                        if (Input.GetKey(InteractKey))
                        {
                            DestroyTerrain();
                        }

                        break;
                    }
                }
            }
        }

        void OnTriggerExit(Collider collider)
        {
            if (m_DestroyableTerrain == null) return;
            if (collider.GetComponentInParent<TerrainTriggerActor>() != null)
            {
                if (m_DestroyTime == DestroyTime.OnExit)
                {
                    DestroyTerrain();
                }
            }
        }

        void DestroyTerrain()
        {
            m_DestroyableTerrain.DestroyThisTerrain();
            m_DestroyableTerrain = null;
        }
    }
}