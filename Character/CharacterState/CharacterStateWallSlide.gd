extends CharacterState
class_name CharacterStateWallSlide

@export_category("Built-In")
@export var HeadTilt : HeadTilter
@export var RayCastLeft : RayCast3D
@export var RayCastRight : RayCast3D
@export_group("States")
@export var defaultState : CharacterStateDefault
@export var slideState : CharacterStateSlide
@export var inAirState : CharacterStateInAir

@export_category("WallSlideConfig")
@export var jumpVelocityWeight : float = 1.0
@export var jumpNormalWeight : float = 2.0

var slideSideRayCast : RayCast3D

func _on_state_enter():
	super._on_state_enter()
	
	if RayCastLeft.is_colliding():
		slideSideRayCast = RayCastLeft
	else:
		slideSideRayCast = RayCastRight

func updatePhysics(delta : float) -> void:
	super.updatePhysics(delta)
	
	if character.is_on_floor() and character.getInputIsSliding():
		character.switchState(slideState)
		return
	
	if character.is_on_floor():
		character.switchState(defaultState)
		return
	
	if !(RayCastLeft.is_colliding() or RayCastRight.is_colliding()) and !character.is_on_floor():
		character.switchState(inAirState)
		return
	
	var tiltDirection = -1.0 if RayCastLeft.is_colliding() else 1.0
	HeadTilt.update(delta, tiltDirection)

func applyGravity(delta : float) -> void:
	if not character.is_on_floor():
		character.velocity.y -= gravity / 2.0 * delta

func justJumped():
	var normal = slideSideRayCast.get_collision_normal()
	
	character.velocity += normal * jumpVelocity
	
	character.switchState(inAirState)
