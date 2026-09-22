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
[Explain your proximity detection algorithm]

**Files Modified:**
- `glsl/teapot.fs.glsl`

**Key Code Snippets:**
```glsl
// Add your proximity detection code here
```

---

### (d) Body Deformation (30 pts)

**Requirements:**
- Indent teapot's mesh when pushed in by the Orb
- Check if vertex is within Orb and move vertex to surface if so
- Demonstrate vertex shader shape modification

**Implementation:**
[Explain your deformation algorithm]

**Files Modified:**
- `glsl/teapot.vs.glsl`
- `A1.js`

**Key Code Snippets:**
```glsl
// Add your deformation code here
```

---

## Part 2: Creative License (Optional - Bonus up to 10 pts)
[If you completed Part 2, describe your creative extensions here]
**Creative Features Implemented:**
- [Feature 1]: [Description]
- [Feature 2]: [Description]
- [etc.]

**Files Modified:**
- [List files you modified for creative features]


## Screenshots
[Include screenshots of your working program showing each part's functionality]
- **Blue Orb:** [Screenshot showing blue orb movement]
- **Lit Teapot:** [Screenshot showing Gouraud shading]
- **Proximity Detection:** [Screenshot showing green coloring]
- **Body Deformation:** [Screenshot showing mesh indentation]

