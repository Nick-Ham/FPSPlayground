extends Node

var debug : DebugHUD = null

func setDebug(inDebug : DebugHUD):
	debug = inDebug

func getDebug() -> DebugHUD:
	return debug

func printStr(inString : String) -> void:
	if debug:
		debug.setText(inString)
