// The value of the "varying" variable is interpolated between values computed in the vertex shader
// The varying variable we passed from the vertex shader is identified by the 'in' classifier
in float intensity;
in vec3 worldPosition;
in float oldDistance;
in float effectRange;
uniform float sphereRadius;
uniform vec3 orbPosition;
uniform bool rainbowMode;

void main() {
 	// TODO: Set final rendered colour to intensity (a grey level)
	gl_FragColor = vec4(intensity*vec3(1.0,1.0,1.0), 1.0);
	float distance = length(orbPosition - worldPosition);

	 if(distance < sphereRadius + effectRange){
		float rainbowProgress = (oldDistance/(sphereRadius + effectRange))*3.0;

		float finalX = clamp(rainbowProgress+0.1, 0.0, 1.0);
		float finalY = clamp(rainbowProgress-finalX, 0.0, 1.0);
		float finalZ = clamp(rainbowProgress-finalX-finalY+0.2, 0.0, 1.0);
		vec3 finalColor = vec3(finalX,finalY,finalZ);

		if(rainbowMode)
			gl_FragColor = gl_FragColor * vec4(finalColor, 1.0);
		else
			gl_FragColor = gl_FragColor * vec4(0.0,1.0,0.0,1.0);
	 }
}
