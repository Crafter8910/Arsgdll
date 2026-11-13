extends Window
#var url = "youtube.com"
var x
var scale
var y
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	#it hides

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Vector2(25,50)
	#position
	#Creates an iframe as a javascript


func _on_close_requested() -> void:
	hide()
	#Deletes element if element is there
