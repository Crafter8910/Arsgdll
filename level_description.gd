extends Control
#var desc = "A remastered version of BROKEN_CITYSCAPE, now that I know how to use the editor to its fullest."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Description.scale = Vector2(pow(30.0/len($Description.text), 0.05),pow(30.0/len($Description.text), 0.05))
	$Description.size.x = 550/$Description.scale.x
