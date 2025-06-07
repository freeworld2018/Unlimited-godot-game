shader_type canvas_item;
uniform vec2 offset = vec2(0.);
uniform float speed: hint_range(1000, 10000,1) = 10000;
uniform float delay:hint_range(0.0, 2.35619, 0.001) = 1.;
uniform float skew = 0.;
uniform float direction: hint_range(-1, 1) = 1;
uniform float r = 0.5;
uniform float b = 1.;
void vertex() {
	float t = (TIME+delay)*speed*0.0001;
	float z =  abs(sin(t))*r + b;
	float z1 =  abs(cos(t))*r + b;
	vec2 vo = VERTEX + offset;
	VERTEX.x = (vo*z - offset).x;
	VERTEX.x += skew*(1.-UV.y);
	VERTEX.x *= direction;
	VERTEX.y = (vo*z1 - offset).y;
}