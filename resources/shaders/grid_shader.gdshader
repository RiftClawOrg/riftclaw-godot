shader_type spatial;
render_mode unshaded;

uniform vec4 grid_color : source_color = vec4(0.04, 0.04, 0.1, 1.0);
uniform vec4 center_color : source_color = vec4(0.0, 0.835, 1.0, 1.0);
uniform float grid_size : hint_range(10.0, 200.0) = 50.0;
uniform float divisions : hint_range(10.0, 100.0) = 50.0;
uniform float line_width : hint_range(0.001, 0.1) = 0.02;

void fragment() {
    vec2 uv = UV * grid_size;
    vec2 grid = abs(fract(uv - 0.5) - 0.5) / fwidth(uv);
    float line = min(grid.x, grid.y);
    
    float alpha = 1.0 - min(line, 1.0);
    alpha = smoothstep(0.0, line_width, alpha);
    
    // Center lines glow
    float center_dist = min(abs(uv.x), abs(uv.y));
    float glow = 1.0 - smoothstep(0.0, 1.0, center_dist);
    vec4 final_color = mix(grid_color, center_color, glow * 0.5);
    
    ALBEDO = final_color.rgb;
    ALPHA = alpha * final_color.a;
}
