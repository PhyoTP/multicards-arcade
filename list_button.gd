extends Button

var cardSet = { "cardCount": 176.0, "creator": "PhyoTP", "id": "4b9fbba8-a0db-475d-82ff-0e71bc15218f", "isPublic": true, "name": "Japanese Sec 2 Kanji Chapter 16-22", "tags": [] }
@onready var options = preload("res://GamemodeOptions.tscn")
var tween: Tween
func _ready() -> void:
	text = cardSet.name
	mouse_entered.connect(_hovered)
	mouse_exited.connect(_reset)
	pressed.connect(_entered)
func _hovered():
	tween = get_tree().create_tween()
	tween.tween_property(self,"text", "by " + cardSet.creator + ", " + str(int(cardSet.cardCount)) + " cards", 0.5)
func _reset():
	tween.kill()
	text = cardSet.name
func _entered():
	var gamemode_options = options.instantiate()
	gamemode_options.id = cardSet.id
	Global.scene_path.append(get_tree().current_scene.duplicate())
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(gamemode_options)
	get_tree().current_scene = gamemode_options
