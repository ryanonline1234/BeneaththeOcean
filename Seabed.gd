extends Node2D

@export var width := 1600
@export var depth := 1600
@export var band_height := 32

var noise := OpenSimplexNoise.new()

func _ready() -> void:
    noise.seed = randi()
    noise.octaves = 3
    noise.period = 40.0
    noise.persistence = 0.6
    update()

func _draw() -> void:
    for y in range(0, depth, band_height):
        var t = float(y) / depth
        var c = Color(0.2 * (1 - t) + 0.0 * t, 0.4 * (1 - t) + 0.05 * t, 0.6 * (1 - t) + 0.05 * t)
        draw_rect(Rect2(Vector2(-width/2, y), Vector2(width, band_height)), c)

    for x in range(-width/2, width/2, 24):
        var h = noise.get_noise_1d(x * 0.1) * 12
        draw_circle(Vector2(x, depth - 12 + h), 8 + int(abs(h)), Color(0.12,0.08,0.06))
