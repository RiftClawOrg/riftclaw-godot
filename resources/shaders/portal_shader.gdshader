shader_type spatial;
render_mode cull_disabled, unshaded;

uniform vec4 portal_color : source_color = vec4(0.0, 1.0, 1.0, 0.5);
uniform float pulse_speed : hint_range(0.1, 5.0) = 1.0;
uniform float swirl_speed : hint_range(0.1, 3.0) = 0.5;
uniform float edge_glow : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec2 center = UV - vec2(0.5);
    float dist = length(center);
    float angle = atan(center.y, center.x);
    
    // Swirling effect
    float swirl = sin(dist * 20.0 - TIME * swirl_speed * 5.0 + angle * 3.0);
    
    // Pulse effect
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed * 3.0);
    
    // Edge glow
    float edge = 1.0 - smoothstep(0.3, 0.5, dist);
    
    // Combine effects
    float alpha = portal_color.a * (0.3 + 0.7 * pulse) * (0.5 + 0.5 * swirl);
    alpha *= edge;
    
    vec3 glow = portal_color.rgb * (1.0 + edge_glow * edge * pulse);
    
    ALBEDO = glow;
    ALPHA = alpha;
}
