shader_type canvas_item;

// 描边颜色（RGBA）
uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // 默认红色
// 描边宽度（像素）
uniform float outline_width : hint_range(0, 10) = 1.0;

void fragment() {
    // 获取原始纹理颜色
    vec4 sprite_color = texture(TEXTURE, UV);
    
    // 如果当前像素是透明区域（需要检测描边）
    if (sprite_color.a == 0.0) {
        // 检查周围像素是否非透明
        float max_alpha = 0.0;
        for (float x = -outline_width; x <= outline_width; x++) {
            for (float y = -outline_width; y <= outline_width; y++) {
                // 计算偏移后的UV坐标
                vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
                // 采样周围像素
                vec4 neighbor = texture(TEXTURE, UV + offset);
                max_alpha = max(max_alpha, neighbor.a);
            }
        }
        
        // 如果周围有非透明像素，则绘制描边
        if (max_alpha > 0.0) {
            COLOR = outline_color;
        } else {
            COLOR = vec4(0.0);
        }
    } else {
        // 非透明区域保持原纹理
        COLOR = sprite_color;
    }
}