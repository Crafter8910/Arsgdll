extends Sprite2D
@export var Region : Rect2
var scaled = false
var isready  =false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  isready = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  if texture and not scaled and isready:
      scaled = true
      region_rect = Rect2(0, 0, (texture.get_width()/Region.size.x) * Region.size.x, (texture.get_width()/Region.size.x)*Region.size.y)
      apply_scale(Vector2(Region.size.x/texture.get_width(),Region.size.x/texture.get_width()))
      return
  #Resizes the texture based on its dimensions and crops it
