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
        var bubble = load("res://Bubble.gd").new()
        bubble.position = Vector2(randf_range(-6,6), randf_range(-6,6))
        add_child(bubble)
        # play bubble sound if available on root
        var root = get_tree().get_current_scene()
        if root and root.has_node("BubbleSound"):
            var bs = root.get_node("BubbleSound")
            if bs and bs is AudioStreamPlayer:
                bs.play()
