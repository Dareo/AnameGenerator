extends Sprite2D

@onready var mouth_anim: AnimationPlayer = $MouthAnim

func _ready():
	mouth_anim.play("mouthidle3")  # This was _read() before, now fixed

# REMOVE THIS – it overrides the animation every frame!
# func _process(delta):
#     $MouthAnim.play("mouthtalk3")

func doTalking(msg: String,delay: float, time: float) -> void:
	await get_tree().create_timer(delay ).timeout
	mouth_anim.play("mouthtalk3")
	await get_tree().create_timer(time).timeout
	mouth_anim.play("mouthidle3")
