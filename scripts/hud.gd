extends CanvasLayer

@onready var collectible_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/CollectibleLabel
@onready var gnome_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/GnomeLabel
@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.collectibles_changed.connect(_on_collectible_changed)
	GameManager.gnomes_changed.connect(_on_gnome_changed)

func _on_score_changed(new_score: int):
	score_label.text = "Score: %s" % new_score

func _on_collectible_changed(collected: int, total: int):
	collectible_label.text = "Collectibles: %s / %s" % [collected, total]

func _on_gnome_changed(stomped: int, total:int):
	gnome_label.text = "Gnomes %s of %s" % [stomped, total]
