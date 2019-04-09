extends Node2D

class_name PlayerStats

var _bee_count: int = 0 setget set_bee_count, get_bee_count
var _honey_count: int = 0 setget set_honey_count, get_honey_count
var _nectar_count: int = 0 setget set_nectar_count, get_nectar_count
var _bee_comb_count: int = 0 setget set_bee_comb_count, get_bee_comb_count
var _honey_comb_count: int = 0 setget set_bee_comb_count, get_honey_comb_count

func _init() -> void:
	SingletonManager.player_stats = self

func set_bee_count(new_val: int) -> void:
	_bee_count = new_val
	$BeeCountLabel.text = str(_bee_count)
	
func get_bee_count() -> int:
	return _bee_count

func set_honey_count(new_val: int) -> void:
	_honey_count = new_val
	$HoneyCountLabel.text = str(_honey_count)
	
func get_honey_count() -> int:
	return _honey_count
	
func set_nectar_count(new_val: int) -> void:
	_nectar_count = new_val
	$NectarCountLabel.text = str(_nectar_count)
	
func get_nectar_count() -> int:
	return _nectar_count
	
func set_bee_comb_count(new_val: int) -> void:
	_bee_comb_count = new_val
	$BeeCombCountLabel.text = str(_bee_comb_count)
	
func get_bee_comb_count() -> int:
	return _bee_comb_count
	
func set_honey_comb_count(new_val: int) -> void:
	_honey_comb_count = new_val
	$HoneyCombCountLabel.text = str(_honey_comb_count)
	
func get_honey_comb_count() -> int:
	return _honey_comb_count
	
func increase_bee_count(amount: int = 1) -> void:
	set_bee_count(_bee_count + amount)

func increase_honey_count(amount: int = 1) -> void:
	set_bee_count(_bee_count + amount)
	
func increase_nectar_count(amount: int = 1) -> void:
	set_bee_count(_bee_count + amount)
	
func increase_bee_comb_count(amount: int = 1) -> void:
	set_bee_comb_count(_bee_comb_count + amount)

func increase_honey_comb_count(amount: int = 1) -> void:
	set_honey_comb_count(_honey_comb_count + amount)