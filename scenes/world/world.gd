extends Node2D


signal life_zone_exit(body)


@onready var life_zone: Area2D = $LifeZone


func _ready():
	$ParallaxBackground.hide()


func _on_life_zone_body_exited(body):
	life_zone_exit.emit(body)
