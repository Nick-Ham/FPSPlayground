extends Node
class_name HeadTilter

@export var Target : Node3D

@export_category("Config")
@export var maxAngle : float = 1.5
@export var rotationSpeed : float = 5

func update(delta : float, percent : float):
	Target.rotation_degrees.z = lerp(Target.rotation_degrees.z, -percent * maxAngle, clamp(delta * rotationSpeed, 0.0, 1.0))
