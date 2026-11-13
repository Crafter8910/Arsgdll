extends VBoxContainer
var json = JSON.new()
@export var window : Window
@export var leveldesc : Control
var levelbeingloaded = "Shattered Cityscape"
var levelbutton = preload("res://level_button.tscn")
var ratings = ['no star', 'star', 'feature', 'epic', 'legendary', 'mythic']
func filterlist(filter: String):
	for i in get_children():
		
		i.show()
		if i.is_in_group("LevelButton"):
			print(i.levelname.erase(len(filter),len(i.levelname)).to_lower())
			if not i.levelname.erase(len(filter),len(i.levelname)).to_lower() == filter:
				i.hide()
func loadlist(filterstring : String = "", filter = false):
	for child in get_children():
		child.queue_free()
	var data = getdata("Data/List.json")
	for i in data.size():
		#For every level in the list data, creating a button for it and load all the stuff
	
		var level = levelbutton.instantiate()
		var leveldata = getdata("res://Levels/" + str(data[i]) + ".json")
		var creatorstring : String
		print(leveldata["name"].erase(len(filterstring),len(leveldata["name"])).to_lower())
		if filter and leveldata["name"].erase(len(filterstring),len(leveldata["name"])).to_lower() == filterstring or not filter:
			for creator in leveldata["creators"]:
				if creatorstring != '':
					creatorstring += ", "
				creatorstring += creator
			level.get_node("Nameofthelevel").text = str(data[i])
			level.get_node("Author").text = creatorstring
			level.levelname = data[i]
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
		
		
func _ready() -> void:
	#Humanized by Crafter
	#Code originally done by the big c(rafter)
	#comments arent needede yknow you can just read what the functions say comments are government propaganda made by the real programmers
	#loadleveldata("Shattered Cityscape")
	loadlist()
func getdata(filename : String):
	#Gets the data based on the file name
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
			
			
			#Gets all the data,
			#and sets the LevelDescription node's nodes (leveldesc is the var for it)
			#to have all the properties that correspond
			
			
			
			
			window.popup()
			var tagdescriptions = getdata("res://Data/TagDescriptions.json")
			var leveldata = getdata("res://Levels/" + Levelname + ".json")
			var list : Array = getdata("res://Data/List.json")
			window.title = Levelname
			window.updateiframe(leveldata["verification"])
			leveldesc.get_node("Levelname").text = Levelname
			for child in leveldesc.get_node("ScrollContainer").get_node("Victors").get_children():
				child.queue_free()
			if leveldata.has("records"):
				print("has records")
				for i in leveldata["records"]:
					var record = preload("res://record.tscn").instantiate()
					record.text = "#" + str(int(leveldata["records"].find(i)+1)) + " " +  str(int(i["hz"])) + " fps - " + i["user"] + " - " + str(int(i["percent"]))  + "%"
					if i.has("enj"):
						record.text += " - enj: " + str(int(i["enj"]))
					record.link = i["link"]
					leveldesc.get_node("ScrollContainer").get_node("Victors").add_child(record)
				leveldesc.get_node("ScrollContainer").get_node("Victors").add_child(preload("res://the_empty_space.tscn").instantiate())
			if leveldata.has("id"):
				leveldesc.get_node("Scratch").show()
				leveldesc.get_node("Turbowarp").show()
				leveldesc.ScratchLink = "https://scratch.mit.edu/projects/" + leveldata["id"]
				leveldesc.TurbowarpLink = "https://turbowarp.org/" + leveldata["id"]
			else:
				leveldesc.get_node("Turbowarp").hide()
				leveldesc.get_node("Scratch").hide()
			if leveldata.has("itchLink"):
				leveldesc.get_node("Itch").show()
				leveldesc.ItchLink = leveldata["itchLink"]
			else:
				leveldesc.get_node("Itch").hide()
			if leveldata.has("codetorchLink"):
				leveldesc.get_node("Codetorch").show()
				leveldesc.CodetorchLink = leveldata["codetorchLink"]
			else:
				leveldesc.get_node("Codetorch").hide()
			if leveldata.has("itchLink2"):
				leveldesc.get_node("LDM").show()
				leveldesc.LDMLink = leveldata["itchLink2"]
			else:
				leveldesc.get_node("LDM").hide()
			
			for tags in leveldesc.get_node("Tags").get_children():
				tags.queue_free()
			if leveldata.has("tags"):
				for newtag in leveldata["tags"]:
					var tagbeingadded = preload("res://tag.tscn").instantiate()
					if tagdescriptions.has("newtag"):
						tagbeingadded.description = tagdescriptions["newtag"]
					else:
						tagbeingadded.description = "No Description"
					tagbeingadded.text = newtag
					leveldesc.get_node("Tags").add_child(tagbeingadded)
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
			


func _on_line_edit_text_changed(new_text: String) -> void:
	filterlist(new_text)# Replace with function body.
