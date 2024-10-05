class_name RandomEffect
extends AudioStreamPlayer

@export var effect_list: Array[AudioStream]

func play_random() -> void:
	self.stop()
	self.stream = effect_list.pick_random()
	self.play()
