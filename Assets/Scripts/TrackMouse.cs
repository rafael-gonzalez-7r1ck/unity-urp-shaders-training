using UnityEngine;

public class TrackMouse : MonoBehaviour
{
    private Material _material;
    private Vector4 _mouse;
    private Camera _camera;

    void Start()
    {
        Renderer rend = GetComponent<Renderer>();
        _material = rend.material;
        _mouse = new Vector4();
        _mouse.z = Screen.height;
        _mouse.w = Screen.width;
        _camera = Camera.main;
    }

    void Update()
    {
        RaycastHit hit;
        if (_camera != null)
        {
            Ray ray = _camera.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray,out hit))
            {
                _mouse.x = hit.textureCoord.x;
                _mouse.y = hit.textureCoord.y;
            }
        }
        _material.SetVector("_Mouse", _mouse);
    }
}
