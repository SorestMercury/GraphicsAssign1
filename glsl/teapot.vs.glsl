// The uniform variable is set up in the javascript code and the same for all vertices
uniform vec3 orbPosition;

// This is a "varying" variable and interpolated between vertices and across fragments.
// The shared variable is initialized in the vertex shader and passed to the fragment shader.
out float intensity;

void main() {

    vec3 worldPosition = (modelMatrix * vec4(position, 1.0)).xyz;
    vec3 worldNormal = normalize(mat3(modelMatrix) * normal);

    vec3 lightDir = normalize(orbPosition - worldPosition);
    intensity = dot(worldNormal, lightDir);

    // TODO: Make changes here for part b, c, d
    // HINT: GLSL PROVIDES THE DOT() FUNCTION 
  	// HINT: INTENSITY IS CALCULATED BY TAKING THE DOT PRODUCT OF THE NORMAL AND LIGHT DIRECTION VECTORS\
    // HINT: Deformation could be achieved by pushing a vertice towards some direction

    // Multiply each vertex by the model matrix to get the world position of each vertex, 
    // then the view matrix to get the position in the camera coordinate system, 
    // and finally the projection matrix to get final vertex position (gl_Position)
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);
    
}
