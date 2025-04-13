shader_type canvas_item;
uniform vec4 flash_color : source_color = vec4(.5,0,0,1);
uniform float strength: hint_range(0.0, 1.0) = 0.0;

uniform float shadow_strength: hint_range(0.0,1.0) = 0.0;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);

	vec4 final_color = mix(texture_color, flash_color, strength); // apply flash
	final_color = mix(final_color, vec4(0,0,0,1), shadow_strength); // apply shadow
	final_color.a = texture_color.a;
    COLOR = final_color;
}