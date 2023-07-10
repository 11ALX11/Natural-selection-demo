extends Node2D


signal life_zone_exit(body)


var life_zone: Area2D


func _ready():
	life_zone = $LifeZone


func _on_life_zone_body_exited(body):
	life_zone_exit.emit(body)
