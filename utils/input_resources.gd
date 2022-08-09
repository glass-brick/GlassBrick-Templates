class_name InputResources

const KEYBOARD_RESOURCES = {
	KEY_ENTER: preload("res://assets/keyboard/enter.png"),
	KEY_SPACE: preload("res://assets/keyboard/spacebar.png"),
	KEY_BACKSPACE: preload("res://assets/keyboard/backspace.png"),
	KEY_TAB: preload("res://assets/keyboard/tab.png"),
	KEY_SHIFT: preload("res://assets/keyboard/shift.png"),
	KEY_CONTROL: preload("res://assets/keyboard/ctrl.png"),
	KEY_ALT: preload("res://assets/keyboard/alt.png"),
	KEY_UP: preload("res://assets/keyboard/up.png"),
	KEY_DOWN: preload("res://assets/keyboard/down.png"),
	KEY_LEFT: preload("res://assets/keyboard/left.png"),
	KEY_RIGHT: preload("res://assets/keyboard/right.png"),
	KEY_A: preload("res://assets/keyboard/a.png"),
	KEY_B: preload("res://assets/keyboard/b.png"),
	KEY_C: preload("res://assets/keyboard/c.png"),
	KEY_D: preload("res://assets/keyboard/d.png"),
	KEY_E: preload("res://assets/keyboard/e.png"),
	KEY_F: preload("res://assets/keyboard/f.png"),
	KEY_G: preload("res://assets/keyboard/g.png"),
	KEY_H: preload("res://assets/keyboard/h.png"),
	KEY_I: preload("res://assets/keyboard/i.png"),
	KEY_J: preload("res://assets/keyboard/j.png"),
	KEY_K: preload("res://assets/keyboard/k.png"),
	KEY_L: preload("res://assets/keyboard/l.png"),
	KEY_M: preload("res://assets/keyboard/m.png"),
	KEY_N: preload("res://assets/keyboard/n.png"),
	KEY_O: preload("res://assets/keyboard/o.png"),
	KEY_P: preload("res://assets/keyboard/p.png"),
	KEY_Q: preload("res://assets/keyboard/q.png"),
	KEY_R: preload("res://assets/keyboard/r.png"),
	KEY_S: preload("res://assets/keyboard/s.png"),
	KEY_T: preload("res://assets/keyboard/t.png"),
	KEY_U: preload("res://assets/keyboard/u.png"),
	KEY_V: preload("res://assets/keyboard/v.png"),
	KEY_W: preload("res://assets/keyboard/w.png"),
	KEY_X: preload("res://assets/keyboard/x.png"),
	KEY_Y: preload("res://assets/keyboard/y.png"),
	KEY_Z: preload("res://assets/keyboard/z.png"),
	KEY_1: preload("res://assets/keyboard/1.png"),
	KEY_2: preload("res://assets/keyboard/2.png"),
	KEY_3: preload("res://assets/keyboard/3.png"),
	KEY_4: preload("res://assets/keyboard/4.png"),
	KEY_5: preload("res://assets/keyboard/5.png"),
	KEY_6: preload("res://assets/keyboard/6.png"),
	KEY_7: preload("res://assets/keyboard/7.png"),
	KEY_8: preload("res://assets/keyboard/8.png"),
	KEY_9: preload("res://assets/keyboard/9.png"),
	KEY_0: preload("res://assets/keyboard/0.png"),
	KEY_F1: preload("res://assets/keyboard/f1.png"),
	KEY_F2: preload("res://assets/keyboard/f2.png"),
	KEY_F3: preload("res://assets/keyboard/f3.png"),
	KEY_F4: preload("res://assets/keyboard/f4.png"),
	KEY_F5: preload("res://assets/keyboard/f5.png"),
	KEY_F6: preload("res://assets/keyboard/f6.png"),
	KEY_F7: preload("res://assets/keyboard/f7.png"),
	KEY_F8: preload("res://assets/keyboard/f8.png"),
	KEY_F9: preload("res://assets/keyboard/f9.png"),
	KEY_F10: preload("res://assets/keyboard/f10.png"),
	KEY_F11: preload("res://assets/keyboard/f11.png"),
	KEY_F12: preload("res://assets/keyboard/f12.png"),
}

const MOUSE_BUTTON_RESOURCES = {
	BUTTON_LEFT: preload("res://assets/keyboard/mouse-left.png"),
	BUTTON_RIGHT: preload("res://assets/keyboard/mouse-right.png"),
	BUTTON_MIDDLE: preload("res://assets/keyboard/mouse-middle.png"),
	BUTTON_WHEEL_DOWN: preload("res://assets/keyboard/mouse-wheel-down.png"),
	BUTTON_WHEEL_UP: preload("res://assets/keyboard/mouse-wheel-up.png"),
	BUTTON_XBUTTON1: 'Mouse button 4',
	BUTTON_XBUTTON2: 'Mouse button 5',
}

const GAMEPAD_BUTTON_RESOURCES = {
	JOY_XBOX_A: preload("res://assets/xbox_buttons/a.png"),
	JOY_XBOX_B: preload("res://assets/xbox_buttons/b.png"),
	JOY_XBOX_X: preload("res://assets/xbox_buttons/x.png"),
	JOY_XBOX_Y: preload("res://assets/xbox_buttons/y.png"),
	JOY_DPAD_UP: preload("res://assets/xbox_buttons/d-pad-up.png"),
	JOY_DPAD_DOWN: preload("res://assets/xbox_buttons/d-pad-down.png"),
	JOY_DPAD_LEFT: preload("res://assets/xbox_buttons/d-pad-left.png"),
	JOY_DPAD_RIGHT: preload("res://assets/xbox_buttons/d-pad-right.png"),
	JOY_L: preload("res://assets/xbox_buttons/lb.png"),
	JOY_R: preload("res://assets/xbox_buttons/rb.png"),
	JOY_L2: preload("res://assets/xbox_buttons/lt.png"),
	JOY_R2: preload("res://assets/xbox_buttons/rt.png"),
	JOY_L3: preload("res://assets/xbox_buttons/l3.png"),
	JOY_R3: preload("res://assets/xbox_buttons/r3.png"),
	JOY_SELECT: preload("res://assets/xbox_buttons/select.png"),
	JOY_START: preload("res://assets/xbox_buttons/start.png"),
}

const GAMEPAD_AXIS_RESOURCES = {
	JOY_ANALOG_LX:
	{
		"negative": preload("res://assets/xbox_buttons/l-stick-left.png"),
		"generic": preload("res://assets/xbox_buttons/l-stick-x-axis.png"),
		"positive": preload("res://assets/xbox_buttons/l-stick-right.png"),
	},
	JOY_ANALOG_LY:
	{
		"negative": preload("res://assets/xbox_buttons/l-stick-up.png"),
		"generic": preload("res://assets/xbox_buttons/l-stick-y-axis.png"),
		"positive": preload("res://assets/xbox_buttons/l-stick-down.png"),
	},
	JOY_ANALOG_RX:
	{
		"negative": preload("res://assets/xbox_buttons/r-stick-left.png"),
		"generic": preload("res://assets/xbox_buttons/r-stick-x-axis.png"),
		"positive": preload("res://assets/xbox_buttons/r-stick-right.png"),
	},
	JOY_ANALOG_RY:
	{
		"negative": preload("res://assets/xbox_buttons/r-stick-up.png"),
		"generic": preload("res://assets/xbox_buttons/r-stick-y-axis.png"),
		"positive": preload("res://assets/xbox_buttons/r-stick-down.png"),
	},
	JOY_ANALOG_L2:
	{
		"generic": preload("res://assets/xbox_buttons/lt.png"),
	},
	JOY_ANALOG_R2:
	{
		"generic": preload("res://assets/xbox_buttons/rt.png"),
	},
}
