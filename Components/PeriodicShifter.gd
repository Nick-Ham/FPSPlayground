extends Node
class_name PeriodicShifter

var totalTime : float = 0.0

@export var Target : Node3D

@export_category("Config")
@export_group("MoveX")
@export var moveX : bool = 0
@export var amplitudeX : float = 1
@export var frequencyX : float = 1
@export var offsetX : float = 0
@export_group("MoveY")
@export var moveY : bool = 0
@export var amplitudeY : float = 1
@export var frequencyY : float = 1
@export var offsetY : float = 0
@export_group("MoveZ")
@export var moveZ : bool = 0
@export var amplitudeZ : float = 1
@export var frequencyZ : float = 1
@export var offsetZ : float = 0

func update(delta : float):
	totalTime += delta
	
	if moveX:
		Target.position.x = sin(offsetX + frequencyX * totalTime) * amplitudeX
	
	if moveY:
		Target.position.y = sin(offsetY + frequencyY * totalTime) * amplitudeY
	
	if moveZ:
		Target.position.z = sin(offsetZ + frequencyZ * totalTime) * amplitudeZ
