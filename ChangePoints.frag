in vec3 pos;
in vec2 uv0;
out vec4 fragColor;

vec3 hsv(float h, float s, float v) {
    vec4 t = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + t.xyz) * 6.0 - vec3(t.w));
    return v * mix(vec3(t.x), clamp(p - vec3(t.x), 0.0, 1.0), s);
}

void main() {
    float h = (pos.y + 5.0) / 10.0;
    vec3 color = hsv(h, 0.8, 0.8);
    vec2 sft = uv0 - 0.5;
    float r = sqrt(pow(sft.x, 2) + pow(sft.y, 2));
    if (r > 0.5) {
        discard;
    } else {
        fragColor = vec4(color, 1.0);
    }
}
