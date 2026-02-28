extends Node2D

@export var spawn_rate := 0.18
@export var burst_count := 1
@export var bubble_scene: PackedScene = preload("res://Bubble.gd")

var _timer := 0.0

func _process(delta: float) -> void:
    _timer += delta
    if _timer >= spawn_rate:
        _timer = 0.0
        _spawn_burst()

func _spawn_burst() -> void:
    for i in range(burst_count):
        var b = Node2D.new()
        # instantiate Bubble.gd as a script node
        var bubble = load("res://Bubble.gd").new()
        bubble.position = Vector2(randf_range(-6,6), randf_range(-6,6))
        add_child(bubble)
