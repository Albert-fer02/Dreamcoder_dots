// Dreamcoder Motion cursor pulse for Ghostty.
// Lightweight shader: only reacts around the terminal cursor and fades quickly.

float sdfRectangle(in vec2 p, in vec2 center, in vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 normalizePosition(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialias(float distance) {
    return 1.0 - smoothstep(0.0, normalizePosition(vec2(2.0), 0.0).x, distance);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    vec4 cursor = vec4(
        normalizePosition(iCurrentCursor.xy, 1.0),
        normalizePosition(iCurrentCursor.zw, 0.0)
    );

    vec2 cursorCenter = vec2(
        cursor.x + cursor.z * 0.5,
        cursor.y - cursor.w * 0.5
    );
    vec2 point = normalizePosition(fragCoord, 1.0);

    float elapsed = iTime - iTimeCursorChange;
    float pulse = 0.5 + 0.5 * sin(iTime * 5.2);
    float settle = 1.0 - smoothstep(0.18, 0.42, elapsed);

    float cursorSdf = sdfRectangle(point, cursorCenter, cursor.zw * 0.5);
    float glowSdf = sdfRectangle(point, cursorCenter, cursor.zw * (0.85 + pulse * 0.35));

    vec3 accent = iCurrentCursorColor.rgb;
    vec3 warmAccent = mix(accent, vec3(1.0, 0.66, 0.34), 0.22);

    float core = antialias(cursorSdf);
    float glow = (1.0 - smoothstep(0.0, 0.028, glowSdf)) * (0.16 + pulse * 0.10) * settle;

    fragColor.rgb = mix(fragColor.rgb, warmAccent, glow);
    fragColor.rgb = mix(fragColor.rgb, accent, core * 0.08);
}
