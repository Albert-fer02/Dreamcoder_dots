// Dreamcoder Cursor Pulse — custom GLSL shader for Ghostty
// Pulses the cursor with the dreamcoder accent color (#d99555 dark, #824f16 light)
// and adds a subtle warm glow trail.
//
// Install: set `custom-shader = shaders/dreamcoder-cursor-pulse.glsl` in ghostty config

#version 330

// --- Uniforms (provided by Ghostty) ---
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_cursor_position;
uniform vec2 u_cursor_size;
uniform bool u_cursor_visible;

// --- Dreamcoder palette ---
// Dark mode accent: #d99555 → vec3(0.851, 0.584, 0.333)
// Light mode accent: #824f16 → vec3(0.510, 0.310, 0.086)
// We use dark mode by default; Ghostty can pass the theme color.

vec3 accent = vec3(0.851, 0.584, 0.333);  // #d99555
vec3 glow   = vec3(0.851, 0.584, 0.333);  // warm gold glow

// --- Pixel input from previous stage ---
in vec2 f_uv;
out vec4 fragColor;
uniform sampler2D f_texture;

void main() {
    vec4 color = texture(f_texture, f_uv);

    if (u_cursor_visible) {
        // Calculate distance from cursor
        vec2 cursor_uv = u_cursor_position / u_resolution;
        vec2 cursor_size_uv = u_cursor_size / u_resolution;
        vec2 delta = abs(f_uv - cursor_uv) / cursor_size_uv;

        // Check if we're near the cursor area
        if (delta.x < 1.5 && delta.y < 1.5) {
            // Smooth pulse based on time
            float pulse = 0.5 + 0.5 * sin(u_time * 3.0);
            float dist = length(delta);

            // Warm glow behind cursor
            float glow_intensity = 0.15 * (1.0 - smoothstep(0.0, 1.5, dist)) * pulse;
            color.rgb += glow * glow_intensity;

            // Subtle accent tint on cursor itself
            if (dist < 0.8) {
                float tint = 0.08 * (1.0 - smoothstep(0.0, 0.8, dist)) * pulse;
                color.rgb = mix(color.rgb, accent, tint);
            }
        }
    }

    fragColor = color;
}
