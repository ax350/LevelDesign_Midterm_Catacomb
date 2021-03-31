using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMoveOriginal : MonoBehaviour
{
    public CharacterController characterController;

    public float speed = 12f;

    Vector3 y_velocity;
    public float gravity = -9.8f;

    public Transform groundCheck;
    public float groundDistance = 0.4f; //radius
    public LayerMask groundMask;
    bool isGrounded;

    public float jumpHeight = 10f;


    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundMask);

        if (isGrounded && y_velocity.y < 0)
        {
            y_velocity.y = -1f;
        }

        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");

        Vector3 move = transform.right * x + transform.forward * z;

        characterController.Move(move * speed * Time.deltaTime);

        y_velocity.y += gravity * Time.deltaTime;

        characterController.Move(y_velocity * Time.deltaTime);

        if (Input.GetButtonDown("Jump") && isGrounded)
        {
            y_velocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);
        }
    }

    public void hardwire()
    {
        transform.position = new Vector3(0f, 1f, 50f);
    }
}