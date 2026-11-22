extends Node2D
@onready var basescale = get_parent().scale
@export var scalefactor = 1.1
var speed = 5
@onready var parent : Control = get_parent()
var mouseentered = false
# Called when the node enters the scene tree for the first time.

#This component, when placed underneath a control node
#Will give the property of increasing the size when hovered over and vice versa

func _ready() -> void:
  if parent is Control:
    parent.mouse_entered.connect(mouse_entered)
    parent.mouse_exited.connect(mouse_exited)
    basescale = get_parent().scale 
    parent.pivot_offset = Vector2(parent.size.x/2, parent.size.y/2)# Replace with function body.
  
func mouse_entered():
  print(get_parent().scale)
  mouseentered = true
func mouse_exited():
  print(basescale)
  mouseentered = false
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
  if mouseentered:
    get_parent().scale += ((basescale*scalefactor)-get_parent().scale)/speed
  else:
    get_parent().scale += ((basescale)-get_parent().scale)/speed
  
