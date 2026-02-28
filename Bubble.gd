extends Node2D

@export var rise_speed := 40.0
@export var lifetime := 1.2
@export var start_radius := 3.0
@export var color := Color(0.9,0.95,1,0.9)

func _ready() -> void:
    set_process(true)
    # animate scale & fade
    var t = create_tween()
    t.tween_property(self, "position:y", position.y - 40 - randf()*20, lifetime)
    t.tween_property(self, "modulate:a", 0.0, lifetime).set_trans(Tween.TRANS_LINEAR)
    t.tween_callback(Callable(self, "queue_free")).set_delay(lifetime)

func _draw() -> void:
    draw_circle(Vector2.ZERO, start_radius, color)
