extends CanvasLayer
class_name DebugHUD

@export var debugLabel : RichTextLabel

func _ready():
	Game.setDebug(self)

func setText(inText : String):
	debugLabel.text = inText
