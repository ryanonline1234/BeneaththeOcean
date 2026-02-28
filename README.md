# Beneath the Ocean — Prototype helper files

This repository now includes small, ready-to-use scripts and assets intended for a sprite-free Godot prototype (jam-friendly).

What I added here:

- `Collectible.tscn` + `Collectible.gd` — a Node2D collectible that detects the player by distance and awards `value` then frees itself. Default pickup radius: 18px. Attach these under `Main/World/CollectibleContainer`.
- `diver_light.shader` — a `canvas_item` shader snippet to create a radial light (use on a full-screen `ColorRect` to darken the scene except near the diver). Set `light_pos` (UV) from code similarly to `diver_screen_pos / viewport_size`.

Quick usage notes

- Open this folder in Godot 4.6 (Project -> Open). Create the node tree described in your design doc and attach these scripts where described.
- Controls (use Godot InputMap): `ui_left`, `ui_right`, `ui_up`, `ui_down`.
- To use `diver_light.shader`: add a full-screen `ColorRect` as a child of `Main`, set its `Material` to a new `CanvasItemMaterial` using this shader, and update the shader param `light_pos` each frame from the player's screen position.

Example code to update shader (attach to your `Main` or `Camera2D`):

```
# assume `overlay` is a ColorRect with the shader material
var mat := overlay.material
var vp := get_viewport().get_visible_rect()
var screen_pos := get_viewport().get_camera_2d().unproject_position(player.global_position)
mat.set_shader_parameter("light_pos", screen_pos / vp.size)
```

If you want, I can continue scaffolding the rest of the prototype (Player, GameManager, Seabed, UI) in this repo on a branch `prototype-scripts`. Say the word and I will add them and push.
