extends CanvasLayer

@onready var collectable_label: Label = $MarginContainer/HBoxContainer/CollectableLabel
@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.collectibles_changed.connect(_on_collectible_changed)

func _on_score_changed(new_score: int):
	score_label.text = "Score: %s" % new_score

func _on_collectible_changed(collected: int, total: int):
	collectable_label.text = "Collectables: %s / %s" % [collected, total]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
