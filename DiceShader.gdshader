shader_type spatial;

uniform int top_value = 1;

void fragment() {
	ALBEDO = vec3(1.0,mod(UV.x,UV.y),mod(UV.y,UV.x));
}
