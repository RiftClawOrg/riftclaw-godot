shader_type spatial;
render_mode cull_disabled;

uniform vec4 crystal_color : source_color = vec4(1.0, 0.0, 1.0, 1.0);
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float fresnel_power : hint_range(0.1, 5.0) = 2.0;

void fragment() {
    // Fresnel effect for edge glow
    vec3 view_dir = normalize(CAMERA_POSITION_WORLD - VERTEX);
    float fresnel = pow(1.0 - abs(dot(NORMAL, view_dir)), fresnel_power);
    
    // Pulse glow
    float pulse = 0.7 + 0.3 * sin(TIME * 2.0);
    
    // Combine crystal color with fresnel glow
    vec3 emission = crystal_color.rgb * glow_intensity * (fresnel + 0.3) * pulse;
    
    // Metallic crystal look
    vec3 albedo = crystal_color.rgb * (0.2 + 0.8 * fresnel);
    
    ALBEDO = albedo;
    EMISSION = emission;
    METALLIC = 0.8;
    ROUGHNESS = 0.1;
}
