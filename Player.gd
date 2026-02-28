extends Node2D

enum Mode { SURFACE, UNDERWATER }

@export var surface_speed := 300.0
@export var swim_speed := 180.0
@export var bob_amp := 6.0
@export var bob_speed := 2.0
@export var oxygen_max := 10.0

var mode = Mode.SURFACE
var velocity := Vector2.ZERO
var bob_timer := 0.0

var oxygen := 0.0
var currency := 0

signal surfaced
signal collected(amount: int)

func _ready():
    oxygen = oxygen_max
    set_process(true)

func _process(delta: float) -> void:
    _handle_input(delta)
    _update_bob(delta)
    update()

func _handle_input(delta: float) -> void:
    var left = Input.is_action_pressed("ui_left")
    var right = Input.is_action_pressed("ui_right")
    var down_just = Input.is_action_just_pressed("ui_down")
    var up_just = Input.is_action_just_pressed("ui_up")

    if mode == Mode.SURFACE:
        var dir = 0
        if left: dir -= 1
        if right: dir += 1
        velocity.x = lerp(velocity.x, dir * surface_speed, 0.2)
        position.x += velocity.x * delta

        if down_just:
            mode = Mode.UNDERWATER
            velocity = Vector2(0, 80)
            emit_signal("surfaced")
    else:
        var move = Vector2.ZERO
        if left: move.x -= 1
        if right: move.x += 1
        if Input.is_action_pressed("ui_up"): move.y -= 1
        if Input.is_action_pressed("ui_down"): move.y += 1
        if move != Vector2.ZERO:
            move = move.normalized()
        velocity = velocity.lerp(move * swim_speed, 0.2)
        position += velocity * delta

        oxygen -= delta
        if oxygen <= 0:
            _force_surface()
        if up_just:
            _surface()

func _force_surface() -> void:
    currency = max(0, currency - int(currency * 0.15))
    _surface()

func _surface() -> void:
    mode = Mode.SURFACE
    oxygen = oxygen_max
    position.y = clamp(position.y, -1000, -100)
    emit_signal("surfaced")

func add_currency(amount: int) -> void:
    currency += amount
    emit_signal("collected", amount)

func _update_bob(delta: float) -> void:
    if mode == Mode.SURFACE:
        bob_timer += delta * bob_speed
        var bob = sin(bob_timer) * bob_amp
        position.y = -80 + bob

func _draw() -> void:
    if mode == Mode.SURFACE:
        _draw_boat()
    else:
        _draw_diver()

func _draw_boat() -> void:
    var hull = PackedVector2Array([Vector2(-24,0), Vector2(24,0), Vector2(20,8), Vector2(-20,8)])
    draw_colored_polygon(hull, Color(0.1,0.1,0.55))
    draw_rect(Rect2(Vector2(-8,-12), Vector2(16,8)), Color(0.2,0.6,0.9))
    draw_line(Vector2(20,-8), Vector2(28,-12), Color(1,0.85,0.2), 2)

func _draw_diver() -> void:
    draw_circle(Vector2(0,0), 8, Color(0.8,0.2,0.2))
    draw_circle(Vector2(6,0), 3, Color(0.15,0.15,0.15))
