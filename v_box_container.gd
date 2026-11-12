extends VBoxContainer
var json = JSON.new()
@export var window : Window
@export var leveldesc : Control
var levelbeingloaded = "Shattered Cityscape"
var levelbutton = preload("res://level_button.tscn")
var ratings = ['no star', 'star', 'feature', 'epic', 'legendary', 'mythic']
func _ready() -> void:
	#Humanized by Crafter
	#Code originally done by the big c(rafter)
	#comments arent needede yknow you can just read what the functions say comments are government propaganda made by the real programmers
	#loadleveldata("Shattered Cityscape")
	var data = getdata("List.json")
	for i in data.size():
		var level = levelbutton.instantiate()
		var leveldata = getdata("res://Levels/" + str(data[i]) + ".json")
		var creatorstring : String
		for creator in leveldata["creators"]:
			if creatorstring != '':
				creatorstring += ", "
			creatorstring += creator
		level.get_node("Nameofthelevel").text = str(data[i])
		level.get_node("Author").text = creatorstring
		level.name = data[i]
		level.get_node("Thumbnail").texture = (load("res://Thumbnails/" + str(leveldata["name"]) + ".png"))
		level.get_node("Position").text = "#" + str(i+1)
		if int(leveldata["rating"]) >= 0 and float(leveldata["rating"]) == round(float(leveldata["rating"])):
			level.get_node("Rating").text = ratings[int(leveldata["rating"])]
		else:
			level.get_node("Rating").text = "no star"
		#print(creators)
		level.pressed.connect
		add_child(level)
	add_child(preload("res://the_empty_space.tscn").instantiate())
func getdata(filename : String):
	if filename.contains("love"):
		print(filename)
	filename.replace("love_", "love.")
	var fileaccess = FileAccess.open(filename, FileAccess.READ)
	var text = fileaccess.get_as_text()
	var parsed = json.parse(text)
	#print(json.data)
	return json.data #the json.data part was 'ai' after searching up how to retrieve json data
func loadleveldata(Levelname: String):
	#if levelbeingloaded != Levelname:
	
			window.popup()
			var leveldata = getdata("res://Levels/" + Levelname + ".json")
			var list : Array = getdata("res://List.json")
			#if leveldata.has("enj"):
		#		print(leveldata["enj"])
			#if leveldata.has("rating"):
			#	print(leveldata["rating"])
			#if leveldata.has("description"):
			#	print(leveldata["description"])
			#if leveldata.has("demonDifficulty"):
		#		print(leveldata["demonDifficulty"])
		#	if leveldata.has("verifier"):
		#		print(leveldata["verifier"])
		#	if leveldata.has("engine"):
		#		print(leveldata["engine"])
			window.title = Levelname
			window.updateiframe(leveldata["verification"])
			leveldesc.get_node("Levelname").text = Levelname
			if leveldata.has("enj"):
				leveldesc.get_node("FlowContainer").get_node("Enjoyment").text = "Enjoyment: " +str(int(leveldata["enj"]))
			else:
				leveldesc.get_node("FlowContainer").get_node("Enjoyment").text = ""
			if int(leveldata["rating"]) >= 0 and float(leveldata["rating"]) == round(float(leveldata["rating"])):
				leveldesc.get_node("Rating").text = ratings[int(leveldata["rating"])]
			else:
				leveldesc.get_node("Rating").text = "no star"
			leveldesc.get_node("FlowContainer").get_node("Difficulty").text = "Difficulty: " + str(leveldata["demonDifficulty"])
			if leveldata.has("hz"):
				leveldesc.get_node("FlowContainer").get_node("Hertz").text = "Hertz verified on: " + str(int(leveldata["hz"]))
			else:
				leveldesc.get_node("FlowContainer").get_node("Hertz").text = ""
			if leveldata["description"]:
				leveldesc.get_node("Description").text = leveldata["description"]
			else:
				leveldesc.get_node("Description").text = ""
			if leveldata["verifier"]:
				leveldesc.get_node("FlowContainer").get_node("Verifier").text = "Verifier: " +str(leveldata["verifier"])
			else:
				leveldesc.get_node("FlowContainer").get_node("Verifier").text = ""
			leveldesc.get_node("Placement").text = "#" + str(int(list.find(Levelname) + 1))
			var creators : String
			for creator in leveldata["creators"]:
				if creators != '':
					creators += ", "
				creators += creator
			leveldesc.get_node("FlowContainer").get_node("Creator").text = "Creators: " + creators
			leveldesc.get_node("FlowContainer").get_node("Engine").text = "Engine: " +leveldata["engine"]
			
