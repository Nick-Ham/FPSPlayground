extends Node
class_name Util

static func safeConnect(inSignal : Signal, inCallable : Callable):
	if inSignal.is_connected(inCallable):
		inSignal.disconnect(inCallable)
	inSignal.connect(inCallable)
