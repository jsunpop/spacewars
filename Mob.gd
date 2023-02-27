extends RigidBody2D

signal shot

export (int) var min_speed
export (int) var max_speed
var mob_types = ['walk','swim','fly']
var score = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Mob_body_entered(body):
	hide()
	emit_signal('shot')
	$CollisionShape2D.disabled = true
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Replace with function body.
