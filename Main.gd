extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	#$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	$Music.play()
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	#$HUD.update_score(score)
	#$HUD.show_message("Get Ready")

func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	mob.position = Vector2(500, 100)
	add_child(mob)

	# Add a PathFollow2D node to the mob.
	var path_follow = PathFollow2D.new()

	#var spawn_pos = Vector2($Enemy_Spawn.position.x, $Enemy_Spawn.position.y)
	#path_follow.position = spawn_pos
	path_follow.set_offset(0)
	path_follow.set_rotate(true)
	$MobPath.add_child(path_follow)
	path_follow.add_child(mob)

	# Set the path for the PathFollow2D node.
	path_follow.set_offset($MobPath/MobSpawnLocation.get_offset())

	# Connect to the area_entered signal of the mob to handle collision.
	mob.connect("area_entered", self, "on_mob_area_entered")

func _on_ScoreTimer_timeout():
	score += 1
	#$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func spawn_item(item_type, item_position):
	if item_type == "Loot":
		if randf() < 0.5:
			var loot = preload("res://LootDrop.tscn")
			var drop = loot.instance()
			drop.global_position = item_position
			add_child(drop)
	if item_type == "Gun":
		var gun = preload("res://Gun.tscn").instance()
		gun.global_position = item_position
		add_child(gun)
