// The value of the "varying" variable is interpolated between values computed in the vertex shader
// The varying variable we passed from the vertex shader is identified by the 'in' classifier
in float intensity;
in vec3 worldPosition;
uniform float sphereRadius;
uniform vec3 orbPosition;

void main() {
 	// TODO: Set final rendered colour to intensity (a grey level)
	gl_FragColor = vec4(intensity*vec3(1.0,1.0,1.0), 1.0);
	float distance = length(orbPosition - worldPosition);

	 if(distance < sphereRadius + 1.5){
		gl_FragColor = gl_FragColor * vec4(vec3(0.0,1.0,0.0), 1.0);
	 }
}
