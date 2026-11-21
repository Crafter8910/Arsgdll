extends Button
@onready var list = get_node(^"/root/Website/Scrollbar of List/MarginContainer/List")

var levelname = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  size = Vector2(299.6,60)
  

func _on_pressed() -> void:
  if levelname == "love_":
    list.loadleveldata("love.")
    return
  if levelname == "Operation: Evolution":
    list.loadleveldata("Operation Evolution")
    return
  list.loadleveldata(levelname)
