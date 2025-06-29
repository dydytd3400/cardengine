// 梯形变形Shader
shader_type canvas_item;
uniform float top_scale = 0.5; // 上边缩放系数

void vertex() {
    if (VERTEX.y > 0.0) {
        VERTEX.x *= mix(1.0, top_scale, abs(VERTEX.y));
    }
}

