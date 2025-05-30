shader_type canvas_item;

instance uniform float blur_amount : hint_range(-2.0, 10.0);
uniform float mix_amount : hint_range(0.0, 1.0);
uniform vec4 color_over : source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {

   vec4 blurred = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
   blurred.a = 1.0;
   //vec4 fin = mix(blurred, color_over, mix_amount);
   COLOR = blurred;//if COLOR.
   float new_color = dot(vec3(COLOR.r,COLOR.g,COLOR.b), vec3(0.2126, 0.7152, 0.0722));
   if (new_color <0.01){
	COLOR.a = 0.0;
}
}