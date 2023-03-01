extends Area2D

var screen_size

export (int) var speed = 200 # Maximum speed range.

func _ready(): 
	$AnimatedSprite.playing = true
	screen_size = get_viewport_rect().size
	#var mob_types = $AnimatedSprite.frames.get_animation_names()
	#$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _process(delta):
	var velocity = Vector2(-100, 0) # Set the desired velocity vector
	if(position.x < 100):
		velocity.y = 100
	velocity = velocity.normalized() * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
