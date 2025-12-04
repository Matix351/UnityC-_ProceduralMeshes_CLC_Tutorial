using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class SimpleProceduralMesh : MonoBehaviour
{
    [SerializeField] private MeshFilter meshFilter;
    private void OnEnable()
    {
        var mesh = new Mesh
        {
            name = "Procedural Mesh"
        };

        //wierzcho³ki trojkatow
        mesh.vertices = new Vector3[]
        {
            Vector3.zero, Vector3.right, Vector3.up,
            new Vector3(1f, 1f)
        };

        //lokalna gora, gdybym stal na wierzcho³ku, zeby silnik wiedzial jak generowac swiatlo 
        //up axis
        mesh.normals = new Vector3[]
        {
            Vector3.back, Vector3.back, Vector3.back,
            Vector3.back
        };

        //koordynaty tekstury z ktorej skladaja sie trojkaty
        //uv= xy
        //znormalizowane(u=0, to poczatek tekstury a u= 1, to koniec)
        mesh.uv = new Vector2[]{
            Vector2.zero, Vector2.right, Vector2.up,
            Vector2.one

        };
        //right axis
        //po prostu tam gdzie jest prawo, na obiekcie (w tym przypadku Vector3. right)
        //w = controls the direction of right axis
        //bo silnik moglby prawa strone wygenerowac do przodu lub do tylu
        mesh.tangents = new Vector4[] {
            new Vector4(1f, 0f, 0f, -1f),
            new Vector4(1f, 0f, 0f, -1f),
            new Vector4(1f, 0f, 0f, -1f),
            new Vector4(1f, 0f, 0f, -1f),


        };


        //front of triangle is when we loook from negative Z direction
        //mesh.triangles = new int[] { 0, 1, 2 };
        //front from positive z direction lookat
        //definiuje trojkat, czyli jak ma byc generowany mesh z wierzcholkow
        //podaje po kolei indeksy, wierzcholka
        mesh.triangles = new int[] { 0, 2, 1 , 1, 2, 3};


        GetComponent<MeshFilter>().mesh = mesh;
        GetComponent<MeshCollider>().sharedMesh = mesh; 
        //meshFilter.mesh = mesh;

        
    }
}
