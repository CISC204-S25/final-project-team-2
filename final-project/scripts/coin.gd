extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
var body_in_area = null
var original_scale = Vector2.ONE

func _ready():
	connect("body_exited", _on_body_exited)
	if sprite:
		original_scale = sprite.scale

func _on_body_entered(body: Node2D) -> void:
	body_in_area = body
	
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", original_scale * 1.2, 0.3)
		tween.tween_property(sprite, "modulate", Color(1.2, 1.2, 0.8), 0.3)

func _on_body_exited(body: Node2D) -> void:
	if body == body_in_area:
		body_in_area = null
		
		if sprite:
			var tween = create_tween()
			tween.tween_property(sprite, "scale", original_scale, 0.3)
			tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.3)

func _process(_delta):
	if body_in_area != null:
		if (body_in_area.is_in_group("player1") and Input.is_action_just_pressed("p1_attack")) or \
		   (body_in_area.is_in_group("player2") and Input.is_action_just_pressed("p2_attack")):
			collect_coin()

func collect_coin():
	animation_player.play("pickup")
	
	body_in_area = null
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
