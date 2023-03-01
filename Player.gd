extends Area2D
signal hit


onready var fireDelayTimer := $FireDelayTimer
export var speed = 400 # How fast the player will move (pixels/sec).
var bullet_path = preload('res://Bullet.tscn')
var screen_size # Size of the game window.
var velocity # The player's movement vector.

export var fireDelay: float = 0.2

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var z = 0
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		 velocity.y -= 1
	if Input.is_action_pressed("shoot_right"):# and #fireDelayTimer.is_stopped():
		#fireDelayTimer.start(fireDelay)
		z = 1
	if Input.is_action_pressed("shoot_left"):# and fireDelayTimer.is_stopped():
		#fireDelayTimer.start(fireDelay)
		z = -1
		
	if velocity.length() > 0 or z != 0:
		velocity = velocity.normalized() * speed
		#$AnimatedSprite.play()
		if z == 1:
			$AnimatedSprite.animation = "shoot"
			$AnimatedSprite.flip_h = false
			shooting_right()
		if z == -1:
			$AnimatedSprite.animation = "shoot"
			$AnimatedSprite.flip_h = true
			shooting_left()
		$AnimatedSprite.play()
		
	else:
		$AnimatedSprite.stop()
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0

	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		#$AnimatedSprite.flip_v = velocity.y > 0 
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

		
func _on_Player_body_entered(body):
	if body is TileMap:
		speed = -1*speed
		#$CollisionShape2D.set_deferred("disabled", true)# Set velocity to zero if collided with TileMap
	else:
		hide() # Player disappears after being hit.
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)


func shooting_right():
	var bullet = bullet_path.instance()
	get_parent().add_child(bullet)
	bullet.position = $right_shot.global_position

func shooting_left():
	var bullet = bullet_path.instance()
	bullet.velocity = Vector2(-1,0)
	get_parent().add_child(bullet)
	bullet.position = $left_shot.global_position

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_area_entered(area):
	if(area.is_in_group("damageable")):
		queue_free()
# Replace with function body.
