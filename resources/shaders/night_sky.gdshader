shader_type sky;

uniform vec3 sky_color : source_color = vec3(0.005, 0.005, 0.015);
uniform float star_density : hint_range(50.0, 500.0) = 250.0;

// Hash function for pseudo-random numbers
float hash(vec3 p) {
    p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
             dot(p, vec3(269.5, 183.3, 246.1)),
             dot(p, vec3(113.5, 271.9, 124.6)));
    return fract(sin(dot(p, vec3(1.0, 1.0, 1.0))) * 43758.5453);
}

void sky() {
    // Base night sky color
    vec3 color = sky_color;
    
    // Get view direction
    vec3 dir = EYEDIR;
    
    // Create stars
    vec3 grid_pos = floor(dir * star_density);
    float star_rand = hash(grid_pos);
    
    // Only draw stars where random value is high enough
    if (star_rand > 0.996) {
        // Twinkle effect
        float twinkle = 0.5 + 0.5 * sin(TIME * 1.5 + star_rand * 10.0);
        float brightness = star_rand * twinkle;
        
        // Add star to sky
        color += vec3(brightness);
    }
    
    COLOR = color;
}
