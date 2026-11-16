extends VBoxContainer

var json = JSON.new()

@export var window : Window
@export var leveldesc : Control
@export var point_equation : OptionButton
@export var list_selector : OptionButton
@export var sort_selector : OptionButton
var the_empty_space = preload("res://the_empty_space.tscn")
var level_being_loaded = "Shattered Cityscape"
var level_button = preload("res://level_button.tscn")
var ratings = ['no star', 'star', 'feature', 'epic', 'legendary', 'mythic']
var what_is_being_loaded = "List"


func filterlist(filter: String):
  for i in get_children():
    i.hide()
    if i.is_in_group("LevelButton") and what_is_being_loaded == "List":
      if i.levelname.erase(len(filter),len(i.levelname)).to_lower() == filter:
        i.show()
    if i.is_in_group("Leaderboard") and what_is_being_loaded == "Leaderboard":
      if i.username.erase(len(filter),len(i.username)).to_lower() == filter:
        i.show()

func loadlist(filterstring : String = "", filter = false):
  what_is_being_loaded = "List"
  for child in get_children():
    print(child)
    if child.is_in_group("LevelButton"):
      print("levelbutton")
      child.queue_free()
    elif child.is_in_group("User"):
      print("user")
      child.hide()
  var data = getlistdata()
  for i in data.size():
    #For every level in the list data, create a button for it and load all the data
    var level = level_button.instantiate()
    var leveldata = getdata("res://Levels/" + str(data[i]) + ".json")
    if not leveldata:
      print("level data could not be found!")
    var creatorstring : String
    #print("#"+ str(i) + ". " + leveldata["name"])
    if filter and leveldata["name"].erase(len(filterstring),len(leveldata["name"])).to_lower() == filterstring or not filter:
      creatorstring = ""
      for creator in leveldata["creators"]:
        if creatorstring != "":
          creatorstring += ", "
        creatorstring += creator
      level.get_node("Name").text = str(data[i])
      level.get_node("Author").text = creatorstring
      level.get_node("Percentage").text = ""
      level.levelname = data[i]
      level.get_node("Thumbnail").texture = load("res://Thumbnails/" + str(leveldata["name"]) + ".png")
      level.get_node("Position").text = "#" + str(i+1)
      if int(leveldata["rating"]) >= 0 and float(leveldata["rating"]) == round(float(leveldata["rating"])):
        level.get_node("Rating").text = ratings[int(leveldata["rating"])]
      else:
        level.get_node("Rating").text = "no star"
    add_child(level)
  add_child(the_empty_space.instantiate())


func _process(_delta: float) -> void:
  if what_is_being_loaded == "List":
    add_theme_constant_override("separation", 10)
  elif what_is_being_loaded == "Leaderboard":
    add_theme_constant_override("separation", 10)


func _ready() -> void:
  #Humanized by Crafter
  #Code originally done by the big c(rafter)
  #comments arent needede yknow you can just read what the functions say comments are government propaganda made by the real programmers
  #loadleveldata("Shattered Cityscape")
  loadlist()
  #for i in range(150):
  #	print("test")
  #	print("Position: " + str(i+1) + " Points: "+ str(calculatepoints(i+1, 2)))
  


func getdata(filename : String):
  #Gets the data based on the file name
  var fileaccess = FileAccess.open(filename, FileAccess.READ)
  var text = fileaccess.get_as_text()
  json.parse(text)
  return json.data 
func calculatepoints(position_of_level, equation :int = 1, percentage = 100, minimumpercent = 67):
  var score = 0
  percentage = float(percentage)
  minimumpercent = float(minimumpercent)
  if equation == 0:
    #Calculates the points, with the pointercrate system modified a little
    score = (140)*(1.02**(1-position_of_level))+10
  if equation == 1:
    #Pointercrate
    if position_of_level >150:
      return 0
    elif position_of_level > 55:
      #print(((54.147-(position_of_level+3.2))))
      score= 1.039035131 * ((185.7 * exp(-0.02715 * position_of_level)) + 14.84)
    elif position_of_level > 35:
      score= 1.0371139743 * ((212.61 * pow(1.036,(1 - position_of_level))) + 25.071)
    elif position_of_level > 20:
      score= ((326.1 * exp(-0.0871 * position_of_level)) + 51.09) * 1.037117142
    else:
      score= (-18.2899079915 * position_of_level) + 368.2899079915
  if percentage < 100:
  #	print("percentagescore" + str(snappedf(score * pow(5,  ((percentage - minimumpercent)/(100.0 - minimumpercent))) /10,0.01)))
    return snappedf(score * pow(5,  ((percentage - minimumpercent)/(100.0 - minimumpercent))) /10,0.01)
  else:
    return snappedf(score, 0.01)
func sort_descending(a,b):
  if a > b:
    return true
  return false


func sort(variable : Array):
  variable.sort_custom(sort_descending)
  return variable

  
func loadleaderboard():
  what_is_being_loaded = "Leaderboard"
  for child in get_children():
    if child.is_in_group("User"):
      child.queue_free()
    elif child.is_in_group("LevelButton"):
      child.hide()

  var listdata = getlistdata()
  var users = []
  var userpoints = []
  var oldpoints = []
  var sortedpoints = []
  if sort_selector.selected == 0:
    for i in listdata:
      var calculatedpoints = calculatepoints(listdata.find(i)+1, point_equation.selected)
      var leveldata = getdata("res://Levels/" + i + ".json")
      if leveldata.has("verifier"):
        if not users.has(leveldata["verifier"]):
          users.append(leveldata["verifier"])
          userpoints.append(calculatedpoints)
          oldpoints.append(calculatedpoints)
          #print(str(leveldata["verifier"]) + " points - " + str(calculatedpoints))
        else:
          userpoints[(users.find(leveldata["verifier"]))] += calculatedpoints
          oldpoints[(users.find(leveldata["verifier"]))] += calculatedpoints
      #	print(str(leveldata["verifier"]) + " points - " + str(calculatedpoints))
      if leveldata.has("records"):
        for record in leveldata["records"]:
          var calculatedrecordpoints = calculatepoints(listdata.find(i)+1, point_equation.selected, record["percent"], leveldata["percentToQualify"])
          #print(listdata.find(i)+1)
        #	print(point_equation.selected)
          #print(record["percent"])
          #print(leveldata["percentToQualify"])
          if not users.has(record["user"]):
            users.append(record["user"])
            userpoints.append(calculatedrecordpoints)
            oldpoints.append(calculatedrecordpoints)
            
          else:
            userpoints[(users.find(record["user"]))] += calculatedrecordpoints
            oldpoints[(users.find(record["user"]))] += calculatedrecordpoints
  elif sort_selector.selected == 1:
    for i in listdata:
      var leveldata = getdata("res://Levels/" + i + ".json")
      for creator in leveldata["creators"]:
        if not users.has(creator):
          users.append(creator)
          userpoints.append(int(leveldata["rating"]))
          oldpoints.append(int(leveldata["rating"]))
        else:
          userpoints[(users.find(creator))] += int(leveldata["rating"])
          oldpoints[(users.find(creator))] += int(leveldata["rating"])
  #oldpoints = userpoints
  sortedpoints = sort(userpoints)
  #print(oldpoints)
  #print(users)
  for points in sortedpoints:
    var user = preload("res://user.tscn").instantiate()
    user.text = users[oldpoints.find(points)] + " - " + str(points)
    user.username = users[oldpoints.find(points)]
    user.points = points
    user.place = sortedpoints.find(points)+1
    users.remove_at(oldpoints.find(points))
    oldpoints.remove_at(oldpoints.find(points))
    user.add_to_group("Leaderboard")
    add_child(user)
  #print(userpoints)
  
    


func loadleveldata(Levelname: String):
  window.popup()
  window.get_node("LevelDescription").show()
  window.get_node("PlayerDescription").hide()
  var tagdescriptions = getdata("res://Data/TagDescriptions.json")
  var leveldata = getdata("res://Levels/" + Levelname + ".json")
  var list : Array = getlistdata()
  window.title = Levelname
  leveldesc.get_node("Levelname").text = Levelname
  for child in leveldesc.get_node("ScrollContainer").get_node("Victors").get_children():
    child.queue_free()
  if leveldata.has("records"):
    print("has records")
    for i in leveldata["records"]:
      var record = preload("res://record.tscn").instantiate()
      record.text = "#" + str(int(leveldata["records"].find(i)+1)) + " " 
      if i.has("hz"):
        record.text +=str(int(i["hz"])) + " fps - "
      record.text += i["user"] + " - " + str(int(i["percent"]))  + "%"
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
  if leveldata.has("percentToQualify"):
    leveldesc.get_node("FlowContainer").get_node("Minimum Percentage").text = "Percent to qualify: " + str(int(leveldata["percentToQualify"])) + "%"
  if leveldata.has("itchLink"):
    leveldesc.get_node("Itch").show()
    leveldesc.ItchLink = leveldata["itchLink"]
  else:
    leveldesc.get_node("Itch").hide()
  if leveldata.has("verification"):
    leveldesc.get_node("Verification").show()
    leveldesc.VerificationLink = leveldata["verification"]
  else:
    leveldesc.get_node("Verification").hide()
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
  leveldesc.get_node("FlowContainer").get_node("Points").text = "Points: " + str(calculatepoints(list.find(Levelname) + 1, point_equation.selected))
  if leveldata.has("demonDifficulty"):
    leveldesc.get_node("FlowContainer").get_node("Difficulty").text = "Difficulty: " + str(leveldata["demonDifficulty"])
    leveldesc.get_node("Difficulty").show()
    leveldesc.get_node("Difficulty").texture = preload("res://Assets/Difficulties.png")
    if leveldata["demonDifficulty"] == "Easy Demon":
      leveldesc.get_node("Difficulty").region_rect = Rect2(4,257,135,125)
    if leveldata["demonDifficulty"] == "Medium Demon":
      leveldesc.get_node("Difficulty").region_rect = Rect2(155,263,128,125)
    if leveldata["demonDifficulty"] == "Hard Demon":
      leveldesc.get_node("Difficulty").region_rect = Rect2(-0.1,125,142.4,131)
    if leveldata["demonDifficulty"] == "Insane Demon":
      leveldesc.get_node("Difficulty").region_rect = Rect2(146,123,147,131)
    if leveldata["demonDifficulty"] == "Extreme Demon":
      leveldesc.get_node("Difficulty").region_rect = Rect2(298,123,165,131)
  else:
    leveldesc.get_node("Difficulty").hide()
  for tags in leveldesc.get_node("Tags").get_children():
    tags.queue_free()
  if leveldata.has("tags"):
    for newtag in leveldata["tags"]:
      var tagbeingadded = preload("res://tag.tscn").instantiate()
      #print(tagdescriptions["Memory"])
      #print(newtag)
      if tagdescriptions.has(newtag):
        tagbeingadded.description = tagdescriptions[newtag]
      else:
        tagbeingadded.description = "No Description"
      tagbeingadded.text = newtag
      leveldesc.get_node("Tags").add_child(tagbeingadded)
  var totalenj = 0
  var amountofpeople = 0
  if leveldata.has("enj"):
    amountofpeople += 1
    totalenj += int(leveldata["enj"])
  if leveldata.has("records"):
    for i in leveldata["records"]:
      if i.has("enj"):		
        totalenj += int(i["enj"])
        amountofpeople += 1
  if amountofpeople > 0:
    leveldesc.get_node("FlowContainer").get_node("Enjoyment").text = "Enjoyment: " +str(int(float(totalenj)/amountofpeople))
  else: 
    leveldesc.get_node("FlowContainer").get_node("Enjoyment").text = "Enjoyment: " + "No Data"
  var ratingbg = leveldesc.get_node("Rating BG")
  if leveldata.has("rating"):
    if int(leveldata["rating"]) > 0 and float(leveldata["rating"]) == round(float(leveldata["rating"])):
      leveldesc.get_node("Rating").text = ratings[int(leveldata["rating"])]
      ratingbg.show() 
      print(int(leveldata["rating"]))
      if int(leveldata["rating"]) == 1:
        ratingbg.hide()
      if int(leveldata["rating"]) == 2:
        ratingbg.texture = preload("res://Assets/Featured.png") 
        ratingbg.scale = Vector2(0.492,0.492)
        ratingbg.position = Vector2(365, -44)
      if int(leveldata["rating"]) == 3:
        ratingbg.texture = preload("res://Assets/Epic.png") 
        ratingbg.scale = Vector2(0.492,0.492)
        ratingbg.position = Vector2(365, -49.0)
      if int(leveldata["rating"]) == 4:
        ratingbg.texture = preload("res://Assets/Legendary.webp") 
        ratingbg.scale = Vector2(0.249,0.249)
        ratingbg.position = Vector2(365.443, -44.48)
      if int(leveldata["rating"]) == 5:
        ratingbg.texture = preload("res://Assets/Mythic.webp") 
        ratingbg.scale = Vector2(0.268,0.268)
        ratingbg.position = Vector2(360, -47)
      
      
    else:
      leveldesc.get_node("Rating").text = "no star"
      ratingbg.hide() 
  else:
    leveldesc.get_node("Rating").text = "no star"
    leveldesc.ratingbg.hide() 
  if leveldata.has("hz"):
    leveldesc.get_node("FlowContainer").get_node("Hertz").text = "Hertz verified on: " + str(int(leveldata["hz"]))
  else:
    leveldesc.get_node("FlowContainer").get_node("Hertz").text = ""
  if leveldata.has("description"):
    leveldesc.get_node("Description").text = leveldata["description"]
  else:
    leveldesc.get_node("Description").text = ""
  for i in leveldesc.get_children():
    if i.is_in_group("Verifier Record"):
      i.queue_free()
    
  if leveldata.has("verifier"):
    var record = preload("res://record.tscn").instantiate()
    record.text = ""
    record.add_to_group("Verifier Record")
    if leveldata.has("hz"):
      record.text = str(int(leveldata["hz"])) + " fps - "
    record.text += leveldata["verifier"] + " - "  + "100%"
    if leveldata.has("enj"):
      record.text += " - enj: " + str(int(leveldata["enj"]))
    record.link = leveldata["verification"]
    record.position = Vector2(452, -45) 
    leveldesc.add_child(record)
    leveldesc.get_node("FlowContainer").get_node("Verifier").text = "Verifier: " +str(leveldata["verifier"])
  else:
    leveldesc.get_node("FlowContainer").get_node("Verifier").text = ""
  leveldesc.get_node("Placement").text = "#" + str(int(list.find(Levelname) + 1))
  var creators : String
  creators = ""
  for creator in leveldata["creators"]:
    if creators != "":
      creators += ", "
    creators += creator
  leveldesc.get_node("FlowContainer").get_node("Creator").text = "Creators: " + creators
  leveldesc.get_node("FlowContainer").get_node("Engine").text = "Engine: " +leveldata["engine"]




func _on_leaderboard_button_pressed() -> void:
  loadleaderboard() # Replace with function body.


func _on_list_button_pressed() -> void:
  loadlist() # Replace with function body.
func getlistdata():
  if list_selector.selected == 0:
    return getdata("res://Data/List.json")
  elif list_selector.selected == 1:
    return getdata("res://Data/Sgd list.json")
  elif list_selector.selected == 2:
    return getdata("res://Data/Unverified list.json")
    
func loaduser(user :String, points :float, place :int):
  window.popup()
  window.get_node("LevelDescription").hide()
  window.get_node("PlayerDescription").show()
  var playerdesc = window.get_node("PlayerDescription")
  
  var list = getlistdata()
  var createdlevels = 0
  var verifiedlevels = 0
  var completedlevels = 0
  
  for child in playerdesc.get_node("CompletedScroll").get_node("Completed").get_children():
    if child is Button:	
      child.queue_free()
  for child in playerdesc.get_node("VerifiedScroll").get_node("Verified").get_children():
    if child is Button:
      child.queue_free()
  for child in playerdesc.get_node("CreatedScroll").get_node("Created").get_children():
    if child is Button:
      child.queue_free()
  playerdesc.get_node("Name").text = user
  playerdesc.get_node("Points").text = str(points)
  playerdesc.get_node("Place").text = "#" +str(place)
  for i in list:
    var leveldata = getdata("res://Levels/" + i + ".json")
    if leveldata.has("verifier"):
      if leveldata["verifier"] == user:
        var level = preload("res://level_button.tscn").instantiate()
        verifiedlevels += 1
        level.get_node("Name").text = str(i)
        level.get_node("Author").text = "+ " + str(calculatepoints(list.find(i)+1, point_equation.selected))
        level.levelname = i
        level.get_node("Thumbnail").texture = load("res://Thumbnails/" + str(leveldata["name"]) + ".png")
      #	else: 
    #			print("could not load thumbnail of: " + level.get_node("Name").text)
        level.get_node("Position").text = "#" + str(list.find(i)+1)
        if int(leveldata["rating"]) >= 0 and float(leveldata["rating"]) == round(float(leveldata["rating"])):
          level.get_node("Rating").text = ratings[int(leveldata["rating"])]
        else:
          level.get_node("Rating").text = "no star"
        
        playerdesc.get_node("VerifiedScroll").get_node("Verified").add_child(level)
      
    if leveldata.has("records"):
      for record in leveldata["records"]:
        if record["user"] == user:
          var level = preload("res://level_button.tscn").instantiate()
          completedlevels +=1
          level.get_node("Name").text = str(i)
          level.get_node("Author").text = "+ " +str(calculatepoints(list.find(i)+1, point_equation.selected))
          level.get_node("Percentage").text = "%" + str(int(record["percent"]))
          level.levelname = i
          level.get_node("Thumbnail").texture = load("res://Thumbnails/" + str(leveldata["name"]) + ".png")
          level.get_node("Position").text = "#" + str(list.find(i)+1)
          if int(leveldata["rating"]) >= 0 and float(leveldata["rating"]) == round(float(leveldata["rating"])):
            level.get_node("Rating").text = ratings[int(leveldata["rating"])]
          else:
            level.get_node("Rating").text = "no star"
          playerdesc.get_node("CompletedScroll").get_node("Completed").add_child(level)
    for creator in leveldata["creators"]:
      if creator == user:
        var level = preload("res://level_button.tscn").instantiate()
        createdlevels +=1
        level.get_node("Name").text = str(i)
        level.get_node("Author").text = "+" + str(int(leveldata["rating"]))
        level.levelname = i
        level.get_node("Thumbnail").texture = load("res://Thumbnails/" + str(leveldata["name"]) + ".png")
        level.get_node("Position").text = "#" + str(list.find(i)+1)
        if int(leveldata["rating"]) >= 0 and float(leveldata["rating"]) == round(float(leveldata["rating"])):
          level.get_node("Rating").text = ratings[int(leveldata["rating"])]
        else:
          level.get_node("Rating").text = "no star"
        playerdesc.get_node("CreatedScroll").get_node("Created").add_child(level)
  playerdesc.get_node("CreatedLabel").text = "Created (" + str(createdlevels) + "):"
  playerdesc.get_node("VerifiedLabel").text = "Verified (" + str(verifiedlevels) + "):"
  playerdesc.get_node("CompletedLabel").text = "Completed (" + str(completedlevels) + "):"

func _on_point_equation_item_selected(index: int) -> void:
  if what_is_being_loaded == "Leaderboard":
    loadleaderboard()


func _on_listtoload_item_selected(index: int) -> void:
  if what_is_being_loaded == "List":
    loadlist()
  elif what_is_being_loaded == "Leaderboard":
    loadleaderboard()


func _on_sort_by_item_selected(index: int) -> void:
  if what_is_being_loaded == "Leaderboard":
    loadleaderboard() # Replace with function body.


func _on_search_filter_text_changed(new_text: String) -> void:
  filterlist(new_text) # Replace with function body.


func _on_record_submission_pressed() -> void:
  if OS.get_name() == "HTML5":
    JavaScriptBridge.eval("window.location.href='%s'" %"https://docs.google.com/forms/d/e/1FAIpQLSeUemIQTn0AyabE5WftDJ5mIE0MdwAd6LprLAjbVXyJnN5CIw/viewform?usp=header") 
  else:
    OS.shell_open("%s" % "https://docs.google.com/forms/d/e/1FAIpQLSeUemIQTn0AyabE5WftDJ5mIE0MdwAd6LprLAjbVXyJnN5CIw/viewform?usp=header")  # Replace with function body.


func _on_discord_pressed() -> void:
  if OS.get_name() == "HTML5":
    JavaScriptBridge.eval("window.location.href='%s'" %"https://discord.gg/7XKh2653m7") 
  else:
    OS.shell_open("%s" % "https://discord.gg/7XKh2653m7")
