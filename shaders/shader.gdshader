shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

// --- Saturation Uniforms ---
// 0.0 = Grayscale, 1.0 = Full Color
uniform float saturation : hint_range(0.0, 1.0) = 1.0;

// --- Wave Uniforms ---
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.0;
uniform float wave_frequency : hint_range(1.0, 50.0) = 15.0;
uniform float wave_speed : hint_range(0.1, 10.0) = 3.0;

// --- Glitch Uniforms ---
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float glitch_block_size : hint_range(5.0, 100.0) = 30.0;
uniform float color_split : hint_range(0.0, 0.05) = 0.01;

// --- Vignette Uniforms ---
// How far from the center the darkness starts (higher = tighter vignette circle)
uniform float vignette_intensity : hint_range(0.0, 3.0) = 0.5;
// Overall darkness/transparency of the vignette edges (0.0 = invisible, 1.0 = pitch black)
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.0;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec2 uv = SCREEN_UV;

    // 1. Wave Displacement
    if (wave_amplitude > 0.0) {
        float wave = sin(uv.y * wave_frequency + TIME * wave_speed) * wave_amplitude;
        uv.x += wave;
    }

    // 2. Glitch Shift
    if (glitch_intensity > 0.0) {
        float time_snap = floor(TIME * 15.0);
        float block_id = floor(uv.y * glitch_block_size);
        float noise = random(vec2(block_id, time_snap));

        if (noise < glitch_intensity) {
            float shift = (random(vec2(time_snap, block_id)) - 0.5) * 0.1 * glitch_intensity;
            uv.x += shift;
        }
    }

    // 3. Sample Screen with RGB Chromatic Aberration
    float split_offset = glitch_intensity * color_split;
    vec4 color_r = texture(screen_texture, uv + vec2(split_offset, 0.0));
    vec4 color_g = texture(screen_texture, uv);
    vec4 color_b = texture(screen_texture, uv - vec2(split_offset, 0.0));

    vec4 color = vec4(color_r.r, color_g.g, color_b.b, 1.0);

    // 4. Saturation Adjustment (Grayscale)
    float grayscale = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(vec3(grayscale), color.rgb, saturation);

    // 5. Vignette Calculation
    if (vignette_opacity > 0.0) {
        // Distance from screen center (0.5, 0.5)
        vec2 center_uv = uv - vec2(0.5);
        float dist = length(center_uv);
        
        // Calculate edge falloff factor
        float vignette = smoothstep(0.8, 0.2, dist * vignette_intensity);
        
        // Darken edges toward black based on opacity strength
        color.rgb = mix(color.rgb * vignette, color.rgb, 1.0 - vignette_opacity);
    }

    COLOR = color;
}