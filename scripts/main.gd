extends Node2D

const BACKGROUND =  preload("res://scenes/background.tscn")
const LEVEL = preload("res://scenes/Level.tscn")
const LEVEL_SUCCESS = preload("res://scenes/LevelSuccessScreen.tscn")
const LEVEL_FAILED = preload("res://scenes/LevelFailedScreen.tscn")

var level
var levelNum = 0
var nextLevelScreen
var restartScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var background = BACKGROUND.instance()
	add_child(background)

	levelNum = -1
	goToNextLevel()
	
func startLevel():
	level.start()
	
func goToNextLevel():
	remove_child(nextLevelScreen)
	levelNum = levelNum + 1
	level = LEVEL.instance()
	level.initializeLevel(levelNum)
	add_child(level)
	
	var timer = get_node("Timer")
	timer.connect("timeout", self, "startLevel")
	timer.start(1)

func restartLevel():
	remove_child(restartScreen)
	levelNum = -1
	goToNextLevel()
	
func levelSuccess():
	remove_child(level)
	nextLevelScreen = LEVEL_SUCCESS.instance()
	add_child(nextLevelScreen)
	
	
func levelFailed():
	remove_child(level)
	restartScreen = LEVEL_FAILED.instance()
	add_child(restartScreen)
	