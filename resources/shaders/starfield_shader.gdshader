shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform vec4 star_color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 star_color2 : source_color = vec4(0.0, 0.835, 1.0, 1.0);
uniform float star_density : hint_range(10.0, 200.0) = 100.0;
uniform float twinkle_speed : hint_range(0.1, 5.0) = 1.0;

// Pseudo-random function
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Generate star positions based on UV and depth
    vec3 pos = vec3(UV * star_density, TIME * 0.1);
    
    // Create star grid
    vec2 grid = fract(pos.xy) - 0.5;
    float dist = length(grid);
    
    // Random star brightness
    float star_rand = rand(floor(pos.xy));
    float twinkle = 0.5 + 0.5 * sin(TIME * twinkle_speed * 3.0 + star_rand * 10.0);
    
    // Star shape
    float star = 1.0 - smoothstep(0.0, 0.1 * star_rand, dist);
    star *= twinkle;
    
    // Color variation
    vec4 color = mix(star_color1, star_color2, star_rand);
    
    ALBEDO = color.rgb;
    ALPHA = star * color.a * star_rand;
}
