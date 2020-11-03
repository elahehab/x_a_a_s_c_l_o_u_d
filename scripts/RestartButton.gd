extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "restart_button_pressed")

func restart_button_pressed():
    get_parent().get_parent().restartLevel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
