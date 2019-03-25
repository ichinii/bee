extends Node2D

enum CombType { BEE_COMB, HONEY_COMB }

var comb_type = CombType.BEE_COMB # CombType

func _ready() -> void:
	#$EvolutionTimer.start()
	
	match comb_type:
		CombType.BEE_COMB:
			$AnimatedSprite.animation = "bee"
		CombType.HONEY_COMB:
			$AnimatedSprite.animation = "honey"

func _on_EvolutionTimer_timeout() -> void:
	$AnimatedSprite.frame = $AnimatedSprite.frame + 1
