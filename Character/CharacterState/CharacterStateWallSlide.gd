extends CharacterState
class_name CharacterStateWallSlide

@export_category("Built-In")
@export var headTilt : HeadTilter
@export var rayCastLeft : RayCast3D
@export var rayCastRight : RayCast3D

@export_category("WallSlideConfig")
@export var jumpVelocityWeight : float = 1.0
@export var jumpNormalWeight : float = 2.0

var slideSideRayCast : RayCast3D

func _on_state_enter():
	super._on_state_enter()
	
	if rayCastLeft.is_colliding():
		slideSideRayCast = rayCastLeft
	else:
		slideSideRayCast = rayCastRight

func updatePhysics(delta : float) -> void:
	super.updatePhysics(delta)
	
	if character.is_on_floor() and character.getInputIsSliding():
		manager.switchState(manager.getSlideState())
		return
	
	if character.is_on_floor():
		manager.switchState(manager.getDefaultState())
		return
	
	if !(rayCastLeft.is_colliding() or rayCastRight.is_colliding()) and !character.is_on_floor():
		manager.switchState(manager.getInAirState())
		return
	
	var tiltDirection = -1.0 if rayCastLeft.is_colliding() else 1.0
	headTilt.update(delta, tiltDirection)

func applyGravity(delta : float) -> void:
	if not character.is_on_floor():
		character.velocity.y -= gravity / 2.0 * delta

func justJumped():
	var normal = slideSideRayCast.get_collision_normal()
	
	character.velocity += normal * jumpVelocity
	
	manager.switchState(manager.getInAirState())
