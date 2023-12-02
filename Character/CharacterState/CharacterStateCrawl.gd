extends CharacterState
class_name CharacterStateCrawl

@export_category("Built-In")
@export var defaultCharacterArea : Area3D
@export var defaultCapsule : CollisionShape3D
@export var crouchCapsule : CollisionShape3D
@export var neck : CharacterNeck
@export var headBob : PeriodicShifter

@export_category("CrawlConfig")
@export var crawlHeight : float = 0.5
@export var headBobTimescale : float = 0.75

func _on_state_enter():
	crouchCapsule.disabled = false
	defaultCapsule.disabled = true
	neck.setHeightTarget(crawlHeight)

func _on_state_exit():
	defaultCapsule.disabled = false
	crouchCapsule.disabled = true
	neck.resetHeight()

func updatePhysics(delta : float) -> void:
	super.updatePhysics(delta)
	
	if !lastInputDirection.is_zero_approx():
		headBob.updateWithTimescale(delta, headBobTimescale)
	
	if !defaultCharacterArea.has_overlapping_bodies():
		manager.switchState(manager.getDefaultState())
