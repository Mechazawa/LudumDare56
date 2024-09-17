extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game() -> void:
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(0)
	$HUD.show_message("Get Ready")

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout() -> void:
	# Random position on the path
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Path is clock-wise, direction points inwards towards scene with some randomness
	var direction = mob_spawn_location.rotation + PI / 2 + randf_range(-PI/4, PI/4)
	var velocity = Vector2(randf_range(150, 250), 0)
	
	var mob = mob_scene.instantiate()
	mob.position = mob_spawn_location.position
	mob.rotation = direction 
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
