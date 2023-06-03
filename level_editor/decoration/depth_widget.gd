extends Control

enum { MODE_BACKGROUND, MODE_FOREGROUND, MODE_SPLIT }
signal depth_changed(new: float)


@export_range(0, 1000, 1) var forground_max_depth := 1000
@export_range(0, 1000, 1, "or_greater") var background_max_depth := 5000
@export_range(0, 1) var background_zero_point := 0.6
@export_range(0, 1) var foreground_zero_point := 0.6

@onready var depth_slider: VSlider = %DepthSlider
@onready var zero_marker: Control = %ZeroMarker

var mode := MODE_BACKGROUND


func _ready() -> void:
	depth_slider.drag_ended.connect(on_drag_completed.unbind(1))
	
	var local_zero := 0.5 * (get_zero_point() + 1)
	depth_slider.value = get_zero_point()
	zero_marker.anchor_bottom = 1 - local_zero
	zero_marker.anchor_top = 1 - local_zero
	
	%Reset.pressed.connect(reset)


func on_drag_completed() -> void:
	var new_depth := get_value(depth_slider.value)
	depth_changed.emit(new_depth)
	
	if new_depth > 400:
		set_mode(MODE_BACKGROUND)
	elif new_depth < -400:
		set_mode(MODE_FOREGROUND)
	else:
		set_mode(MODE_SPLIT)


func set_mode(new: int) -> void: pass
#	if mode == new:
#		return
#
#	mode = new
#	update_zero_marker()
#	reset()


func get_value(raw_depth : float) -> float:
	var final := 0.0
	var raw := raw_depth
	
	match mode:
		MODE_BACKGROUND:
			var zero_point := -background_zero_point
			final = minf(
				(raw - 1) / (1 - zero_point) + 1,
				(raw + 1) / (1 + zero_point) - 1
			)
		MODE_FOREGROUND:
			var zero_point := -foreground_zero_point
			final = maxf(
				(raw - 1) / (1 - zero_point) + 1,
				(raw + 1) / (1 + zero_point) - 1
			)
		MODE_SPLIT:
			final = raw
	
	if final >= 0:
		return lerpf(0, background_max_depth, final)
	else:
		return -lerpf(0, forground_max_depth, -final)


func reset() -> void:
	depth_changed.emit(0.0)
	move_slider_to(get_zero_point(), 0.5)


func update_zero_marker() -> void:
	var t := create_tween()
	var point := 1 - (get_zero_point() + 1) * 0.5
	
	t.tween_property(
		zero_marker, "anchor_bottom", point, 0.95
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.parallel()
	t.tween_property(
		zero_marker, "anchor_bottom", point, 0.95
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func move_slider_to(value: float, time : float) -> void:
	(
		create_tween()
		.tween_property(depth_slider, "value", value, time)
		.set_trans(Tween.TRANS_BACK)
		.set_ease(Tween.EASE_OUT)
	)

func get_zero_point() -> float:
	return (
		-background_zero_point if mode == MODE_BACKGROUND else
		foreground_zero_point if mode == MODE_FOREGROUND else
		0
	)
