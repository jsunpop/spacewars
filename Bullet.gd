extends Area2D

signal shothit

var speed = 300
var velocity = Vector2(1,0)
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(delta):
	velocity = (velocity.normalized() * speed)
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_area_entered(area):
	if area.is_in_group('damageable'):
		emit_signal("shothit")
		area.free()
		queue_free()


func _on_Bullet_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group('damageable'):
		body.free()
		queue_free()
	if body is TileMap:
		queue_free()



func _on_Bullet_shothit():
	get_parent().spawn_item("Loot", global_position) # Replace with function body.
