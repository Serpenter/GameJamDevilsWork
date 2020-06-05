extends Node2D


var slider


func _ready():
	slider = $CanvasLayer/MarginContainer/CenterContainer/HSlider


func set_progress(progress):
	slider.value = progress * 100
