shader_type canvas_item;

uniform float time = 0.5;
uniform vec2 amp = vec2(2.0, 2.0);

void vertex()
{
	VERTEX.x += cos(TIME * time + VERTEX.x - VERTEX.y) * amp.x; 
	VERTEX.y += sin(TIME * time + VERTEX.x - VERTEX.y) * amp.y; 
}