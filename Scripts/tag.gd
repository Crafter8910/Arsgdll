extends Button
var description = "No Description"
var mouseentered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if mouseentered:
		$Description.text = description
		$Description.show()
		$Description.global_position = get_global_mouse_position()
		$Description.global_position.x -= $Description.size.x/10
		$Description.global_position.y -= 15
	else:
		$Description.hide()


func _on_pressed() -> void:
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	mouseentered = true # Replace with function body.


func _on_mouse_exited() -> void:
	mouseentered = false # Replace with function body.
