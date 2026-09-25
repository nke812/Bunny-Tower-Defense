shader_type canvas_item;

uniform bool ativo = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (ativo) {
        float grayscale = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
        COLOR = vec4(vec3(grayscale), tex_color.a);
    } else {
        COLOR = tex_color;
    }
}