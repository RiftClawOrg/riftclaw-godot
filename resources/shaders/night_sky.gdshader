shader_type sky;

uniform vec3 sky_top : source_color = vec3(0.005, 0.005, 0.02);
uniform vec3 sky_bottom : source_color = vec3(0.02, 0.02, 0.06);
uniform float star_density : hint_range(50.0, 500.0) = 300.0;
uniform float star_brightness : hint_range(0.5, 3.0) = 1.5;

// Hash function for pseudo-random numbers
float hash(vec3 p) {
    p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
             dot(p, vec3(269.5, 183.3, 246.1)),
             dot(p, vec3(113.5, 271.9, 124.6)));
    return fract(sin(dot(p, vec3(1.0, 1.0, 1.0))) * 43758.5453);
}

// Smooth noise
float noise(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float n = mix(
        mix(
            mix(hash(i), hash(i + vec3(1,0,0)), f.x),
            mix(hash(i + vec3(0,1,0)), hash(i + vec3(1,1,0)), f.x),
            f.y
        ),
        mix(
            mix(hash(i + vec3(0,0,1)), hash(i + vec3(1,0,1)), f.x),
            mix(hash(i + vec3(0,1,1)), hash(i + vec3(1,1,1)), f.x),
            f.y
        ),
        f.z
    );
    return n;
}

void sky() {
    // Get view direction
    vec3 dir = normalize(EYEDIR);
    
    // Gradient sky from bottom to top
    float t = clamp((dir.y + 0.2) * 2.0, 0.0, 1.0);
    vec3 color = mix(sky_bottom, sky_top, t);
    
    // Star generation
    vec3 star_pos = dir * star_density;
    vec3 grid = floor(star_pos);
    vec3 frac_pos = fract(star_pos) - 0.5;
    
    // Check nearby grid cells
    float star_intensity = 0.0;
    
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            for (int z = -1; z <= 1; z++) {
                vec3 cell = grid + vec3(float(x), float(y), float(z));
                float star_rand = hash(cell);
                
                // Star threshold - lower = more stars
                if (star_rand > 0.992) {
                    vec3 cell_center = (cell + 0.5) / star_density;
                    float dist = distance(dir, normalize(cell_center));
                    
                    // Star size varies
                    float size = 0.003 + star_rand * 0.005;
                    float brightness = 1.0 - smoothstep(0.0, size, dist);
                    
                    if (brightness > 0.0) {
                        // Twinkle effect
                        float twinkle = 0.6 + 0.4 * sin(TIME * (1.0 + star_rand * 2.0) + star_rand * 10.0);
                        
                        // Star color (slight variation)
                        float color_rand = hash(cell + vec3(100.0));
                        vec3 star_color;
                        if (color_rand > 0.7) {
                            star_color = vec3(1.0, 0.9, 0.8); // Warm white
                        } else if (color_rand > 0.4) {
                            star_color = vec3(0.8, 0.9, 1.0); // Cool white
                        } else {
                            star_color = vec3(1.0, 1.0, 1.0); // Pure white
                        }
                        
                        float intensity = brightness * twinkle * star_brightness;
                        color += star_color * intensity;
                    }
                }
            }
        }
    }
    
    COLOR = color;
}
