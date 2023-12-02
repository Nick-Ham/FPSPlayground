extends Node
class_name StateManager

@export_category("Built-In")
@export var character : Character
@export_group("States")
@export var defaultState : CharacterStateDefault
@export var inAirState : CharacterStateInAir
@export var slideState : CharacterStateSlide
@export var sprintState : CharacterStateSprint
@export var wallSlideState : CharacterStateWallSlide
@export var crawlState : CharacterStateCrawl

var currentState : CharacterState

func _ready():
	currentState = defaultState

func switchState(inState : CharacterState):
	character.switchState(inState)

func getDefaultState() -> CharacterStateDefault:
	return defaultState

func getInAirState() -> CharacterStateInAir:
	return inAirState

func getSlideState() -> CharacterStateSlide:
	return slideState

func getSprintState() -> CharacterStateSprint:
	return sprintState

func getWallSlideState() -> CharacterStateWallSlide:
	return wallSlideState

func getCrawlState() -> CharacterStateCrawl:
	return crawlState
