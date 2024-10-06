extends Node2D

enum Stamp {NONE, DEAD, SAVED}

@export var photo: Texture2D
@export var patient_name: String
@export_multiline var dossier_text: String
@export var stamp: Stamp = Stamp.NONE

signal player_ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Photo.texture = photo
	$Barcode.text = str(photo.resource_path.hash())
	$PatientName.text = patient_name
	
	match stamp:
		Stamp.NONE:
			$ContinueHint.text = "Press attack to begin"
		Stamp.DEAD:
			$ContinueHint.text = "Press attack to retry"
			$StampDead.visible = true
		Stamp.SAVED:
			$ContinueHint.text = "Press attack to continue"
			$StampSaved.visible = true
	
	var lines = dossier_text.split("\n")
	for i in $DossierText.get_child_count():
		var child = $DossierText.get_child(i)
		
		# todo this is because their parent is node instead of node2d
		if i < len(lines):
			child.text = lines[i]
			child.scale = self.scale
			child.position *= self.scale
			child.position += self.position
			child.visible = true
		else:
			child.visible = false
	
	init_greeble($Stains.get_children().pick_random())
	init_greeble($Tape.get_children().pick_random())
	
func init_greeble(greeble: Sprite2D) -> void:
	greeble.visible = true
	greeble.position = self.position
	greeble.scale = self.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_tool"):
		player_ready.emit()

func _on_continue_hint_timer_timeout() -> void:
	$ContinueHint.visible = true
	Anima.Node($ContinueHint).anima_animation("fadeIn", 1).play()
