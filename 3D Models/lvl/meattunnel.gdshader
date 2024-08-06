shader_type spatial;

uniform sampler2D albedo_tex;
uniform sampler2D noise_1;
uniform sampler2D noise_2;
uniform float distort;
uniform float speed;
uniform float scale;

void vertex() {
	vec3 uv_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float wave_height = texture(noise_1, uv_world_pos.xz / scale + TIME * speed).r;
	VERTEX.x += wave_height * 2.0;
	VERTEX.z += wave_height * 2.0;
}

void fragment() {
	//vec2 noise_uv = UV + TIME * speed;
	//vec2 noise = vec2(texture(noise_1,noise_uv).r, texture(noise_2,noise_uv).r);
	//vec2 base_uv = UV + noise * distort;
	
	ALBEDO = texture(albedo_tex, UV).rgb;
	SPECULAR = 0.13;
	ROUGHNESS = 0.56;
}
