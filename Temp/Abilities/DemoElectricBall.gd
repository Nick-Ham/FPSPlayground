extends Node3D
class_name DemoBall

@export var rotationSpeedX : float = 1
@export var rotationSpeedY : float = 1
@export var rotationSpeedZ : float = 1

@export var Pivot : Node3D

func _process(delta):
	Pivot.rotation.x += rotationSpeedX * delta
	Pivot.rotation.y += rotationSpeedY * delta
	Pivot.rotation.z += rotationSpeedZ * delta
