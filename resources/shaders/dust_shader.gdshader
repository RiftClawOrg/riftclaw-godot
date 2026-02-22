shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled;

uniform vec4 dust_color : source_color = vec4(0.5, 0.7, 1.0, 0.3);
uniform float dust_density : hint_range(10.0, 100.0) = 50.0;
uniform float drift_speed : hint_range(0.1, 2.0) = 0.5;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    // Create dust particles
    float time = TIME * drift_speed;
    vec3 grid = fract(world_pos * dust_density + vec3(time, time * 0.7, time * 0.3));
    float dist = length(grid - 0.5);
    
    // Random dust
    float dust_rand = rand(floor(world_pos.xz * dust_density + time));
    float particle = 1.0 - smoothstep(0.0, 0.3, dist);
    particle *= dust_rand;
    
    // Fade with distance
    float depth = length(world_pos - CAMERA_POSITION_WORLD);
    float fade = 1.0 - smoothstep(5.0, 50.0, depth);
    
    ALBEDO = dust_color.rgb;
    ALPHA = particle * dust_color.a * fade * 0.5;
}
