extends Sprite2D

@onready var mouth_animator_2: AnimationPlayer = $MouthAnimator2
@onready var eye: Sprite2D = $"../Eye"




func _ready():
	mouth_animator_2.play("TalkIdle")

func doTalking(msg: String,delay: float, time: float) -> void:
	await get_tree().create_timer(delay ).timeout
	mouth_animator_2.play("Talking")
	await get_tree().create_timer(time).timeout
	mouth_animator_2.play("TalkIdle")
