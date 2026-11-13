extends Control
var TurbowarpLink = "https://google.com"
var ScratchLink = ""
var ItchLink = ""
var LDMLink = ""
var CodetorchLink = ""
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Description.scale = Vector2(pow(30.0/len($Description.text), 0.05),pow(30.0/len($Description.text), 0.05))
	$Description.size.x = 550/$Description.scale.x
	#Makes the description text smaller if theres more text so it doesnt explode


func _on_turbowarp_pressed() -> void:
	if OS.get_name() == "HTML5":
		JavaScriptBridge.eval("window.location.href='%s'" %TurbowarpLink) 
	else:
		OS.shell_open("%s" % TurbowarpLink) 


func _on_scratch_pressed() -> void:
	if OS.get_name() == "HTML5":
		JavaScriptBridge.eval("window.location.href='%s'" %ScratchLink) 
	else:
		OS.shell_open("%s" % ScratchLink)  # Replace with function body.


func _on_itch_pressed() -> void:
	if OS.get_name() == "HTML5":
		JavaScriptBridge.eval("window.location.href='%s'" %ItchLink) 
	else:
		OS.shell_open("%s" % ItchLink)  # Replace with function body.


func _on_ldm_pressed() -> void:
	if OS.get_name() == "HTML5":
		JavaScriptBridge.eval("window.location.href='%s'" %LDMLink) 
	else:
		OS.shell_open("%s" % LDMLink)  # Replace with function body.


func _on_codetorch_pressed() -> void:
	if OS.get_name() == "HTML5":
		JavaScriptBridge.eval("window.location.href='%s'" %CodetorchLink) 
	else:
		OS.shell_open("%s" % CodetorchLink) # Replace with function body.
