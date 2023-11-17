extends Camera3D
class_name LerpCam

@export var Target : Node3D

@export var followStrength : float = 6
@export var rotationStrength : float = 3

func _ready():
	#set_as_top_level(true)

func _process(delta):
	#global_position = lerp(global_position, Target.global_position, delta * followStrength)
	global_rotation.y = lerp_angle(global_rotation.y, Target.global_rotation.y, delta * rotationStrength)
