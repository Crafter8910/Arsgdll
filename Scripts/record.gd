extends Button

var link = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	if OS.get_name() == "HTML5":
		JavaScriptBridge.eval("window.location.href='%s'" %link) 
	else:
		OS.shell_open("%s" % link) 
 # Replace with function body.
