extends Node

@export var collectible_scene: PackedScene = preload("res://Collectible.tscn")
@export var spawn_width := 800
@export var spawn_depth := 1200
@export var initial_spawn := 24
@export var player_path := NodePath("World/Player")
@export var dolphin_scene: PackedScene = preload("res://Dolphin.tscn")
@export var rare_spawn_interval := 18.0
@export var dolphin_spawn_interval := 12.0

onready var player := get_node_or_null(player_path)
onready var container := get_node_or_null("World/CollectibleContainer")
onready var enemies_container := get_node_or_null("World/Enemies")

@export var enemy_scene: PackedScene = preload("res://Enemy.tscn")
@export var enemy_spawn_interval := 10.0
var _time_since_enemy := 0.0

var _time_since_rare := 0.0
var _time_since_dolphin := 0.0

func _ready() -> void:
    randomize()
    if container == null:
        container = get_node("World").get_node("CollectibleContainer")
    if player == null:
        player = get_node("World").get_node("Player")
    _spawn_initial()
    if player:
        player.connect("surfaced", Callable(self, "_on_player_surfaced"))
        player.connect("collected", Callable(self, "_on_collected"))

func _process(delta: float) -> void:
    _time_since_rare += delta
    _time_since_dolphin += delta
    if _time_since_rare >= rare_spawn_interval:
        _time_since_rare = 0.0
        _spawn_rare()
    if _time_since_dolphin >= dolphin_spawn_interval:
        _time_since_dolphin = 0.0
        _spawn_dolphin()
    _time_since_enemy += delta
    if _time_since_enemy >= enemy_spawn_interval:
        _time_since_enemy = 0.0
        _spawn_enemy()
    # check enemy proximity to player and apply damage cooldowns
    if enemies_container and player:
        for e in enemies_container.get_children():
            if not e: continue
            var dist = e.position.distance_to(player.position)
            var now = OS.get_ticks_msec() / 1000.0
            if dist < 28 and now - e.last_hit > e.hit_cooldown:
                # damage player oxygen
                if player.has_method("add_currency"):
                    # knockback
                    player.position += Vector2(sign(player.position.x - e.position.x) * 16, -8)
                if player.has_method("_force_surface"):
                    # reduce oxygen by 2 seconds
                    player.oxygen = max(0, player.oxygen - 2.0)
                e.last_hit = now

func _spawn_initial() -> void:
    for i in range(initial_spawn):
        _spawn_collectible_random()

func _spawn_collectible_random() -> void:
    var c = collectible_scene.instantiate()
    var x = randf_range(-spawn_width/2, spawn_width/2)
    var y = randf_range(40, spawn_depth)
    c.position = Vector2(x, y)
    c.value = randi_range(1, 5)
    c.color = Color(1, 0.8 - randf() * 0.6, 0.2 + randf() * 0.8)
    container.add_child(c)

func _spawn_rare() -> void:
    var c = collectible_scene.instantiate()
    var x = randf_range(-spawn_width/2, spawn_width/2)
    var y = randf_range(80, spawn_depth)
    c.position = Vector2(x, y)
    c.value = randi_range(10, 25)
    c.color = Color(1.0, 0.9, 0.6)
    container.add_child(c)

func _spawn_dolphin() -> void:
    if container.get_child_count() == 0: return
    var idx = randi() % container.get_child_count()
    var target = container.get_child(idx)
    var d = dolphin_scene.instantiate()
    var px = player.position.x + (randf() < 0.5 ? -300 : 300)
    d.position = Vector2(px, clamp(player.position.y - 80 + randf()*80, -200, 200))
    if target:
        d.target = target.get_path()
    get_node("World").add_child(d)

func _spawn_enemy() -> void:
    if enemies_container == null:
        enemies_container = get_node("World").get_node("Enemies")
    var en = enemy_scene.instantiate()
    var x = randf_range(-spawn_width/2, spawn_width/2)
    var y = randf_range(80, spawn_depth)
    en.position = Vector2(x, y)
    enemies_container.add_child(en)

func _on_collected(amount: int) -> void:
    # placeholder for future logic
    pass

func _on_player_surfaced() -> void:
    if not player: return
    var ppos = player.position
    if abs(ppos.x) < 60:
        var main = get_node("../")
        var shop = main.get_node("UI/ShopPanel") if main.has_node("UI/ShopPanel") else null
        if shop:
            shop.visible = true
        sell_all()

func sell_all() -> int:
    if not player: return 0
    var gained = player.currency
    player.currency = 0
    if gained > 0:
        player.oxygen_max += int(gained / 20) * 2
        player.oxygen = player.oxygen_max
    return gained

func upgrade_oxygen(cost: int) -> bool:
    if not player: return false
    if player.currency < cost:
        return false
    player.currency -= cost
    player.oxygen_max += 2
    player.oxygen = player.oxygen_max
    return true
