shader_type canvas_item;

uniform float frequency = 60;
uniform float depth = 0.005;
uniform float offset = 1.f;
uniform float wave_offset = 1.f;
uniform float time_scale = 1.0f;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv.x += sin(uv.y * frequency + TIME * time_scale) * depth;
	uv.x = clamp(uv.x, 0.0, 1.0);
	
	vec2 uvR = SCREEN_UV;
	uvR.x += sin(uvR.y * frequency + TIME *  time_scale + wave_offset) * depth + offset;
	uvR.x = clamp(uvR.x, 0.0, 1.0);
	
	vec2 uvB = SCREEN_UV;
	uvB.x += sin(uvB.y * frequency + TIME - wave_offset) * depth - offset;
	uvB.x = clamp(uvB.x, 0.0, 1.0);
	
	vec3 c = textureLod(SCREEN_TEXTURE, uv, 0.0).rgb;
	vec3 cR = textureLod(SCREEN_TEXTURE,  uvR, 0.0).rgb;
	vec3 cB = textureLod(SCREEN_TEXTURE, uvB, 0.0).rgb;
	c.r = cR.r;
	c.b = cB.b;
	COLOR.rgb = c;
}
