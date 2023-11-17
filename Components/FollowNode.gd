extends Node3D
class_name FollowNode

@export var Target : Node3D

@export var followStrength : float = 6
@export var rotationStrength : float = 1

var lastPosition : Vector3
var currentPosition : Vector3

var lastRotation : Vector3
var currentRotation : Vector3

func _ready():
	set_as_top_level(true)
	global_position = Target.global_position

func _process(delta):
	lastPosition = currentPosition
	currentPosition = Target.global_position
	
	lastRotation = currentRotation
	currentRotation = Target.global_rotation
	
	var physicsFrameFraction = Engine.get_physics_interpolation_fraction()
	
	var newPosition : Vector3 = lerp(lastPosition, currentPosition, physicsFrameFraction)
	var newRotationY : float = lerp_angle(lastRotation.y, currentRotation.y, physicsFrameFraction)
	
	global_position = lerp(global_position, newPosition, delta * followStrength)
	global_rotation.y = lerp_angle(global_rotation.y, newRotationY, delta * rotationStrength)
	
	
	#global_position = lerp(global_position, Target.global_position, delta * followStrength)
	#global_rotation.y = lerp_angle(global_rotation.y, Target.global_rotation.y, delta * rotationStrength)
	
