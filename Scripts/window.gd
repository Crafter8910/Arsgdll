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
	x = int($X.text)
	#x 
	y = int($Y.text)
	#y
	scale = float($Scale.text)
	#scale
	#all 3 of these correlates to the nodes beneath it bc i was using it before for bug tesitng
	position = Vector2(25,50)
	#position
	#Creates an iframe as a javascript
	var js = """
		var element = document.getElementById('video');
		var canvas = document.getElementById('canvas');
		var rect = canvas.getBoundingClientRect();
		var width;
		var height;
		var centerX = rect.left + (rect.width / 2);
		var centerY = rect.top + (rect.height / 2);
		var aspectratio = 5/2.6;
		if (rect.width/rect.height > aspectratio){
			height = rect.height * %s;	
			width = height * aspectratio;
		} else{
			width = rect.width * %s;
			height = width / aspectratio;
			
		}

		element.style.width =  width + 'px';
		element.style.height = height +'px';
		element.style.left = %s*(rect.width/1152)-width/2 + 'px';
		element.style.top = %s*(rect.height/648)-height/2 + 'px';
		""" % [scale, scale, x, y]
		#function that updates iframe
	JavaScriptBridge.eval(js, true)
	#This just runs javascript

func _on_close_requested() -> void:
	print("close iframe")
	#Deletes the iframe
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
		var element = document.getElementById('video');
		if (element) element.remove();
		""", true)
	hide()
	#Deletes element if element is there
func updateiframe(url):
	print(url)
	print("update iframe")
	var js = """
		var element = document.getElementById('video');
		if (!element) {
			var element = document.createElement('iframe');
			element.id = 'video'
			element.allowFullscreen = true;
			document.body.appendChild(element);
		}
		element.src = '%s';
		element.style.position = 'absolute';
		""" % [url]
	#Updates the actual source/url but not any properties, badly named oopsied
		#function that updates iframe
	JavaScriptBridge.eval(js, true)
