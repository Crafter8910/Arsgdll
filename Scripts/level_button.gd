extends Button

var levelname = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	size = Vector2(299.6,60)


func _on_pressed() -> void:
	if get_parent().name.to_lower() == "list":
		if levelname == "love_":
			get_parent().loadleveldata("love.")
			return
		get_parent().loadleveldata(levelname)
