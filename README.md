# CS 4361 Assignment 1: Hello Teapot! Introduction to Three.js, WebGL, and Shaders

**Student Name:** Dylan Horton
**Student Number:** 2021706202
**NetID:** DRH220003

## Assignment Overview

This assignment introduces Three.js, WebGL, and shader programming through the creation of an interactive 3D scene featuring a "Teapot" character and a magical "Orb" that interacts with it.

## Part 1: Required Elements (100 pts)

### (a) Moving & Coloring the Orb (20 pts)

**Requirements:**
- Modify sphere vertex shader to move the orb in response to keyboard input
- Change orb color to blue using fragment shader
- Must modify shaders, not use Three.js functions

**Implementation:**
The movement for the orb was already implemented. For changing the color, I simply had to edit one line of the fragment shader file. There is a vector with Red, Green, Blue, and Alpha values to represent color. This means to get blue, we set it to (0.0,0.0,1.0,1.0).

**Files Modified:**
- `glsl/sphere.fs.glsl`

**Key Code Snippets:**
```glsl
// glsl/sphere.fs.glsl
gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
```

---

### (b) Lighting the Teapot (20 pts)

**Requirements:**
- Implement Gouraud shading
- Light teapot based on cosine of angle between vertex normal and direction to orb center
- Orb should "activate" and light different parts of teapot as it moves

**Implementation:**
I chose to do the majority of my math with vec3 objects since the orbPosition uniform was a vec3. I adjust the orb position so that the warping effect lines up bettter later. worldPosition is preserved as a vec4 for the final gl_Position calculation at the end.

After thse initial steps, I convert the vertex's normal vector to world space by multiplying it with the model matrix. Specifically, mat3(modelMatrix) since we do not need the translation information for a normal vector. We actually remove the scaling factor too by normalizing the result. This leaves us with a normal that has been correctly rotated to account for the change from model to world space. Then, we can do simple vector math (adjustedOrbPos - worldPosition) to get a vector that points from the vertex to the orb in world space. If we normalize this vector as well, then we can leverage the formula  𝐚⋅𝐛=|𝐚||𝐛|cos(𝜃). Since |a| and |b| are both 1, this is effectively 𝐚⋅𝐛=cos(𝜃), which is exactly what we want to base the intensity off of. We store this in an out variable to be accessed by the fragment shader.

**Files Modified:**
- `glsl/teapot.vs.glsl`
- `glsl/teapot.fs.glsl`

**Key Code Snippets:**
```glsl
// teapot.vs.glsl
vec3 adjustedOrbPos = orbPosition;
adjustedOrbPos.y += 0.9;

vec4 worldPositionVec = (modelMatrix * vec4(position, 1.0));
worldPosition = worldPositionVec.xyz;

vec3 worldNormal = normalize(mat3(modelMatrix) * normal);

vec3 lightDir = normalize(adjustedOrbPos - worldPosition);

intensity = dot(worldNormal, lightDir);

//teapot.fs.glsl
gl_FragColor = vec4(intensity*vec3(1.0,1.0,1.0), 1.0);
```

---

### (c) Proximity Detection (30 pts)

**Requirements:**
- Color teapot fragments green when in close proximity to the sphere
- Check if teapot fragment is within specified distance to sphere
- Implement in fragment shader

**Implementation:**
Distance is calculated by doing orbPosition - worldPosition, which gives a vector pointing from the vertex to the orb. If this vector's length is below a predetermiend threshold set in effectRange, then color the pixel green. I pass this variable from the vertex shader because I want to use the same value for the warping effect later.

**Files Modified:**
- `glsl/teapot.fs.glsl`

**Key Code Snippets:**
```glsl
// glsl/teapot.fs.glsl
float distance = length(orbPosition - worldPosition);

if(distance < sphereRadius + effectRange){
    gl_FragColor = gl_FragColor * vec4(0.0,1.0,0.0,1.0);
}

// glsl/teapot.vs.glsl
out float effectRange;

main(){effectRange = 1.25;}
```

---

### (d) Body Deformation (30 pts)

**Requirements:**
- Indent teapot's mesh when pushed in by the Orb
- Check if vertex is within Orb and move vertex to surface if so
- Demonstrate vertex shader shape modification

**Implementation:**
Since we already have the world position in a vec3 from earlier steps, we simply have to do worldPosition - adjustedOrbPos to get a vector pointing from the orb to the vertex. oldDistance will be used for a bonus feature later. If the length of our vector is less than the sphereRadius + effectRange, then we want to push it to the outside of the effect range by sliding it along that same vector. We use a formula to do just that. If P represents our original point, and D the distance we want to move along a unit/direction vector V, then we calculate our new position as P + DV. We apply this to our scenario and the final world position vector is adjustedOrbPos + normalize(orbToVertex) * (sphereRadius + effectRange). This pushes all pixels to be outside of the range we set, creating a force-field warping effect around the orb.

**Files Modified:**
- `glsl/teapot.vs.glsl`
- `A1.js`

**Key Code Snippets:**
```glsl
// glsl/teapot.vs.glsl
effectRange = 1.25;

vec3 adjustedOrbPos = orbPosition;
adjustedOrbPos.y += 0.9;

vec4 worldPositionVec = (modelMatrix * vec4(position, 1.0));
worldPosition = worldPositionVec.xyz;

vec3 orbToVertex = worldPosition - adjustedOrbPos;
oldDistance = length(orbToVertex);

if((length(orbToVertex) < sphereRadius+effectRange)){
    worldPositionVec = vec4(adjustedOrbPos + normalize(orbToVertex) * (sphereRadius + effectRange),1.0);
}

gl_Position = projectionMatrix * viewMatrix * worldPositionVec;
```
```JavaScript
// A1.js
const radius = 1.0;
const sphereRadius = { type: 'f', value: radius}

const teapotMaterial = new THREE.ShaderMaterial({
  uniforms: {
    orbPosition: orbPosition,
    sphereRadius: sphereRadius,
        rainbowMode: rainbowMode
  }
});

const sphereGeometry = new THREE.SphereGeometry(radius, 32.0, 32.0);
```

---

## Part 2: Creative License (Optional - Bonus up to 10 pts)
[If you completed Part 2, describe your creative extensions here]

**Creative Features Implemented:**
I added a toggle that will switch the proximity detection from Green to "Rainbow" mode. This can be activated by pressing semicolon. The function takes the distance that the vertex was from the sphere *before* warping occurs and uses that to calculate the color of the pixel.

**Files Modified:**
- `A1.js`
- `teapot.fs.glsl`

**Key Code Snippets**
```glsl
// teapot.fs.glsl
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
```

```JavaScript
// A1.js
let wasSemicolonPressed = false;

if (keyboard.pressed(";") && !wasSemicolonPressed)
    rainbowMode.value = !rainbowMode.value;
wasSemicolonPressed = keyboard.pressed(";");
```

## Screenshots
[Include screenshots of your working program showing each part's functionality]
- **Blue Orb/Lighting:** ![Screenshot showing blue orb movement](https://cdn.phototourl.com/free/2026-09-22-2aa2d2ef-1781-4856-a868-fc0a605e917a.png)
- **Proximity Detection:** ![Screenshot showing green coloring](https://cdn.phototourl.com/free/2026-09-22-553b4739-824a-4821-beda-d51be9d72318.png)
- **Body Deformation:** ![Screenshot showing mesh indentation](https://cdn.phototourl.com/free/2026-09-22-a7865c1a-4ee5-4b7e-920d-8743b9506e6c.png)
- **Rainbow Mode** ![Screenshot of rainbow mode](https://cdn.phototourl.com/free/2026-09-22-e930c6eb-83d1-42e3-ba69-262225d56c69.png)

