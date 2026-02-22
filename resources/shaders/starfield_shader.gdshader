shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled;

uniform vec4 star_color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 star_color2 : source_color = vec4(0.0, 0.835, 1.0, 1.0);
uniform float star_density : hint_range(10.0, 200.0) = 50.0;
uniform float twinkle_speed : hint_range(0.1, 5.0) = 1.0;

// Pseudo-random function
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Generate star positions based on UV
    vec2 uv = UV * star_density;
    vec2 grid_uv = fract(uv) - 0.5;
    float dist = length(grid_uv);
    
    // Random value for this grid cell
    float star_rand = rand(floor(uv));
    
    // Only show stars for some cells
    if (star_rand < 0.7) {
        ALBEDO = vec3(0.0);
        ALPHA = 0.0;
        return;
    }
    
    // Twinkle effect
    float twinkle = 0.5 + 0.5 * sin(TIME * twinkle_speed * 3.0 + star_rand * 10.0);
    
    // Star shape - sharp point
    float star = 1.0 - smoothstep(0.0, 0.15, dist);
    star *= twinkle;
    
    // Color variation
    vec3 color = mix(star_color1.rgb, star_color2.rgb, star_rand);
    
    ALBEDO = color * star;
    ALPHA = star;
}
