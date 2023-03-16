in vec3 attr_pos;
in vec2 attr_uv0;
uniform mat4 modelViewProjection;
out vec3 pos;
out vec2 uv0;

void main() {
    float sx = sin(pitch);
    float cx = cos(pitch);
    mat3 mx = mat3(
        1.0, 0.0, 0.0,
        0.0,  cx, -sx,
        0.0,  sx,  cx);
    float sy = sin(yaw);
    float cy = cos(yaw);
    mat3 my = mat3(
         cy, 0.0,  sy,
        0.0, 1.0, 0.0,
        -sy, 0.0,  cy);

    pos = attr_pos;
    uv0 = attr_uv0;
    float x = (float((((gl_VertexID+1) / 2) % 2) * 2.0) - 1.0) * length;
    float y = (float((( gl_VertexID    / 2) % 2) * 2.0) - 1.0) * length;
    gl_Position = modelViewProjection * vec4(pos + mx * my * vec3(x, y, 0.0), 1.0);
}
