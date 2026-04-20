//shader_type canvas_item;
//
//void vertex() {
	//// Called for every vertex the material is visible on.
//}
//
//void fragment() {
	//// Called for every pixel the material is visible on.
//}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform float angle = -0.3;
uniform float position = 0.5;
uniform float spread = 0.5;
uniform float cutoff = 0.1;
uniform float falloff = 0.2;
uniform float edge_fade = 0.15;
uniform float speed = 1.0;
uniform float ray1_density = 8.0;
uniform float ray2_density = 30.0;
uniform float ray1_intensity = 0.3;
uniform float ray2_intensity = 0.3;
uniform vec4 color : source_color = vec4(1.0, 0.9, 0.65, 0.8);

void fragment() {
    vec2 uv = UV;
    float time = TIME * speed;
    
    // Rotate UV for angle
    float s = sin(angle);
    float c = cos(angle);
    uv = vec2(c * uv.x - s * uv.y, s * uv.x + c * uv.y);
    
    // Generate rays using noise-like functions
    float rays = sin(uv.x * ray1_density + time) * ray1_intensity;
    rays += sin(uv.x * ray2_density + time * 0.5) * ray2_intensity;
    
    // Cutoff and mask
    float mask = smoothstep(position - spread, position, uv.x) - smoothstep(position, position + spread, uv.x);
    float visibility = smoothstep(0.0, 1.0, uv.y);
    
    COLOR = color;
    COLOR.a *= rays * mask * visibility;
}