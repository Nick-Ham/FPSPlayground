extends Node3D
class_name PhysicsInterpolator

@export var Target : Node3D

var previousTransform : Transform3D
var currentTransform : Transform3D

func _ready():
	set_as_top_level(true)
	
	global_transform = Target.global_transform

func _process(_delta):
	previousTransform = currentTransform
	currentTransform = Target.global_transform
	
	var physicsFrameFraction = Engine.get_physics_interpolation_fraction()
	global_transform = previousTransform.interpolate_with(currentTransform, physicsFrameFraction)
