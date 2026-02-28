extends Node2D

@onready var player := $World/Player
@onready var oxygen_label := $UI/OxygenLabel
@onready var currency_label := $UI/CurrencyLabel
@onready var shop_panel := $UI/ShopPanel
@onready var sell_button := $UI/ShopPanel/SellButton
@onready var upgrade_button := $UI/ShopPanel/UpgradeButton
@onready var canvas_mod := $CanvasModulate
@onready var light_overlay := $LightOverlay

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    set_process(true)
    sell_button.pressed.connect(Callable(self, "_on_sell_pressed"))
    upgrade_button.pressed.connect(Callable(self, "_on_upgrade_pressed"))
    # load audio streams
    var collect_path = "res://audio/collect.wav"
    var bubble_path = "res://audio/bubble.wav"
    var surface_path = "res://audio/surface.wav"
    if ResourceLoader.exists(collect_path):
        var s = load(collect_path)
        if has_node("CollectSound"):
            $CollectSound.stream = s
    if ResourceLoader.exists(bubble_path):
        var b = load(bubble_path)
        if has_node("BubbleSound"):
            $BubbleSound.stream = b
    if ResourceLoader.exists(surface_path):
        var su = load(surface_path)
        if has_node("SurfaceSound"):
            $SurfaceSound.stream = su

func _process(delta: float) -> void:
    if player:
        oxygen_label.text = "Oxygen: %0.1f" % player.oxygen
        currency_label.text = "$%d" % player.currency
        _update_depth_tint()
        _update_light_overlay()

func _update_depth_tint() -> void:
    # simple tint: lerp to darker blue the deeper the player is
    var depth_factor = clamp((player.position.y - -100) / 800.0, 0.0, 1.0)
    var tint = Color(1.0 - depth_factor*0.4, 1.0 - depth_factor*0.45, 1.0 - depth_factor*0.6)
    canvas_mod.color = tint

func _update_light_overlay() -> void:
    # update shader light_pos param (convert player global pos to viewport UV)
    if not light_overlay.material: return
    var cam = get_node("Camera2D")
    if not cam: return
    var vp = get_viewport().get_visible_rect()
    var screen_pos = cam.get_camera_screen_center() + (player.position - cam.position)
    var uv = screen_pos / vp.size
    light_overlay.material.set_shader_parameter("light_pos", uv)

func _on_sell_pressed() -> void:
    var gm = get_node_or_null("GameManager")
    if gm and gm.has_method("sell_all"):
        gm.sell_all()
        shop_panel.visible = false

func _on_upgrade_pressed() -> void:
    var gm = get_node_or_null("GameManager")
    if gm and gm.has_method("upgrade_oxygen"):
        if gm.upgrade_oxygen(20):
            shop_panel.visible = false
