extends LineEdit

func _gui_input(event):
	var gameplay = get_node("/root/GameplayScreen")
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_BACKSPACE:
			accept_event()
		elif !gameplay.timer_active:
			if !gameplay.is_first_letter:
				accept_event()
		elif event.keycode == KEY_TAB:
			gameplay.tab_autofill()


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		$".".grab_focus()
