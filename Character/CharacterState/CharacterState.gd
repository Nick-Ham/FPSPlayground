extends Node
class_name CharacterState

var lastInputDirection : Vector2 = Vector2()
var lastIsSprinting : bool = false
var lastIsSliding : bool = false

@export_category("Config")
@export var acceleration : float = 2200.0
@export var maxSpeed : float = 2.0
@export var maxSpeedEnforcement : float = 10.0
@export var friction : float = 300.0
@export var jumpVelocity : float = 4.5

@export_category("Built-In")
@export var character : Character

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

signal update_input_request

func _on_state_enter():
	emit_signal("update_input_request")

func _on_state_exit():
	pass

func update(_delta : float) -> void:
	pass

func updatePhysics(delta : float) -> void:
	applyGravity(delta)
	
	var direction = convertInputToDirection(lastInputDirection, character.transform.basis)
	
	var addedVelocity = calculateAddedPlanarVelocity(direction, delta)
	
	character.velocity += addedVelocity
	
	character.velocity = clampVelocityPlanar(character.velocity, delta)
	
	if character.is_on_floor() or character.is_on_wall():
		character.velocity = applyFriction(character.velocity, delta)
	
	character.move_and_slide()

func addNewInputDirection(inInputDirection : Vector2) -> void:
	lastInputDirection = inInputDirection

func addNewIsSprinting(inIsSprinting : bool) -> void:
	lastIsSprinting = inIsSprinting

func addNewIsSliding(inIsSliding : bool) -> void:
	lastIsSliding = inIsSliding

func justJumped() -> void:
	pass

func justSlid() -> void:
	pass

func applyGravity(delta : float) -> void:
	if not character.is_on_floor():
		character.velocity.y -= gravity * delta

func calculateAddedPlanarVelocity(inDirection : Vector3, delta : float) -> Vector3:
	var addedVelocity = Vector3()
	if inDirection:
		addedVelocity.x += inDirection.x * acceleration * delta * delta
		addedVelocity.z += inDirection.z * acceleration * delta * delta
	
	return addedVelocity

func convertInputToDirection(inInputDirection : Vector2, inBasis : Basis) -> Vector3:
	return (inBasis * Vector3(inInputDirection.x, 0, inInputDirection.y)).normalized()

func clampVelocityPlanar(inVelocity : Vector3, delta : float) -> Vector3:
	var velocity2D = Vector2(inVelocity.x, inVelocity.z)
	velocity2D = lerp(velocity2D, velocity2D.limit_length(maxSpeed), maxSpeedEnforcement * delta)
	var result = Vector3(velocity2D.x, inVelocity.y, velocity2D.y)
	
	return result

func applyFriction(inVelocity : Vector3, delta : float) -> Vector3:
	var frictionDirection = -inVelocity.normalized()
	var length = inVelocity.length()
	var speedMultiplier = (length / maxSpeed) + 1
	var outVelocity = frictionDirection * friction * speedMultiplier * delta * delta
	
	return outVelocity + inVelocity
