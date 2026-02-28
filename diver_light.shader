shader_type canvas_item;

# Radial darkening shader: attach to a full-screen ColorRect and set `light_pos`
# `light_pos` should be in UV coords (0..1) where the diver is (e.g. Vector2(0.5,0.4)).

uniform vec2 light_pos : hint_range(0.0, 1.0) = vec2(0.5, 0.5);
uniform float radius : hint_range(0.01, 1.0) = 0.25;
uniform float softness : hint_range(0.0, 0.5) = 0.12;
uniform float intensity : hint_range(0.0, 1.0) = 0.8;

void fragment() {
    float d = distance(UV, light_pos);
    float t = smoothstep(radius, radius - softness, d);
    // output a darkening color; use this on a ColorRect with blend mode 'mix' or 'multiply'
    COLOR = vec4(0.0, 0.0, 0.0, t * intensity);
}
