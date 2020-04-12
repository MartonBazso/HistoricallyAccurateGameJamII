extends KinematicBody


signal human_hit
var already_hit = false

func _ready():
	$Monk/AnimationPlayer.play("Walk")

func _on_Area_body_entered(body):
	if !already_hit:
		already_hit = true
		var material = SpatialMaterial.new()
		material.albedo_color = Color(1,0,0)
		$Indicator.set_surface_material(0, material)
		emit_signal("human_hit")



