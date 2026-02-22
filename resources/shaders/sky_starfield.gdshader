shader_type sky;

uniform vec4 sky_top : source_color = vec4(0.02, 0.02, 0.06, 1.0);
uniform vec4 sky_bottom : source_color = vec4(0.01, 0.01, 0.04, 1.0);
uniform float star_density : hint_range(100.0, 500.0) = 300.0;
uniform float star_brightness : hint_range(0.5, 2.0) = 1.2;
uniform float twinkle_speed : hint_range(0.1, 2.0) = 0.8;

float rand(vec3 co) {
    return fract(sin(dot(co.xyz, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

void sky() {
    // Get sky direction
    vec3 dir = normalize(EYEDIR);
    
    // Gradient background
    float t = clamp((dir.y + 0.3) / 0.6, 0.0, 1.0);
    vec3 sky_color = mix(sky_bottom.rgb, sky_top.rgb, t);
    
    // Star generation based on spherical coordinates
    vec3 star_pos = dir * star_density;
    vec3 grid = floor(star_pos);
    vec3 frac_pos = fract(star_pos);
    
    // Check surrounding grid cells for stars
    float star_intensity = 0.0;
    
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            for (int z = -1; z <= 1; z++) {
                vec3 cell = grid + vec3(float(x), float(y), float(z));
                float star_rand = rand(cell);
                
                // Only create stars in some cells (15% chance)
                if (star_rand > 0.85) {
                    vec3 cell_center = (cell + 0.5) / star_density;
                    float dist = distance(dir, normalize(cell_center));
                    
                    // Twinkle effect
                    float twinkle = 0.7 + 0.3 * sin(TIME * twinkle_speed * 3.0 + star_rand * 10.0);
                    
                    // Star brightness falls off with distance
                    float brightness = 1.0 - smoothstep(0.0, 0.005, dist);
                    brightness *= twinkle * star_rand;
                    
                    star_intensity = max(star_intensity, brightness);
                }
            }
        }
    }
    
    // Add stars to sky
    vec3 star_color = vec3(1.0, 0.95, 0.9); // Slightly warm white
    sky_color += star_color * star_intensity * star_brightness;
    
    COLOR = sky_color;
}
