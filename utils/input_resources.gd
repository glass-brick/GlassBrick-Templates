class_name InputResources

const KEYBOARD_RESOURCES = {
	KEY_ENTER: preload("res://assets/input/keyboard/enter.tres"),
	KEY_SPACE: preload("res://assets/input/keyboard/spacebar.tres"),
	KEY_BACKSPACE: preload("res://assets/input/keyboard/backspace.tres"),
	KEY_TAB: preload("res://assets/input/keyboard/tab.tres"),
	KEY_SHIFT: preload("res://assets/input/keyboard/shift.tres"),
	KEY_CTRL: preload("res://assets/input/keyboard/ctrl.tres"),
	KEY_ALT: preload("res://assets/input/keyboard/alt.tres"),
	KEY_UP: preload("res://assets/input/keyboard/up.tres"),
	KEY_DOWN: preload("res://assets/input/keyboard/down.tres"),
	KEY_LEFT: preload("res://assets/input/keyboard/left.tres"),
	KEY_RIGHT: preload("res://assets/input/keyboard/right.tres"),
	KEY_A: preload("res://assets/input/keyboard/a.tres"),
	KEY_B: preload("res://assets/input/keyboard/b.tres"),
	KEY_C: preload("res://assets/input/keyboard/c.tres"),
	KEY_D: preload("res://assets/input/keyboard/d.tres"),
	KEY_E: preload("res://assets/input/keyboard/e.tres"),
	KEY_F: preload("res://assets/input/keyboard/f.tres"),
	KEY_G: preload("res://assets/input/keyboard/g.tres"),
	KEY_H: preload("res://assets/input/keyboard/h.tres"),
	KEY_I: preload("res://assets/input/keyboard/i.tres"),
	KEY_J: preload("res://assets/input/keyboard/j.tres"),
	KEY_K: preload("res://assets/input/keyboard/k.tres"),
	KEY_L: preload("res://assets/input/keyboard/l.tres"),
	KEY_M: preload("res://assets/input/keyboard/m.tres"),
	KEY_N: preload("res://assets/input/keyboard/n.tres"),
	KEY_O: preload("res://assets/input/keyboard/o.tres"),
	KEY_P: preload("res://assets/input/keyboard/p.tres"),
	KEY_Q: preload("res://assets/input/keyboard/q.tres"),
	KEY_R: preload("res://assets/input/keyboard/r.tres"),
	KEY_S: preload("res://assets/input/keyboard/s.tres"),
	KEY_T: preload("res://assets/input/keyboard/t.tres"),
	KEY_U: preload("res://assets/input/keyboard/u.tres"),
	KEY_V: preload("res://assets/input/keyboard/v.tres"),
	KEY_W: preload("res://assets/input/keyboard/w.tres"),
	KEY_X: preload("res://assets/input/keyboard/x.tres"),
	KEY_Y: preload("res://assets/input/keyboard/y.tres"),
	KEY_Z: preload("res://assets/input/keyboard/z.tres"),
	KEY_1: preload("res://assets/input/keyboard/1.tres"),
	KEY_2: preload("res://assets/input/keyboard/2.tres"),
	KEY_3: preload("res://assets/input/keyboard/3.tres"),
	KEY_4: preload("res://assets/input/keyboard/4.tres"),
	KEY_5: preload("res://assets/input/keyboard/5.tres"),
	KEY_6: preload("res://assets/input/keyboard/6.tres"),
	KEY_7: preload("res://assets/input/keyboard/7.tres"),
	KEY_8: preload("res://assets/input/keyboard/8.tres"),
	KEY_9: preload("res://assets/input/keyboard/9.tres"),
	KEY_0: preload("res://assets/input/keyboard/0.tres"),
	KEY_F1: preload("res://assets/input/keyboard/f1.tres"),
	KEY_F2: preload("res://assets/input/keyboard/f2.tres"),
	KEY_F3: preload("res://assets/input/keyboard/f3.tres"),
	KEY_F4: preload("res://assets/input/keyboard/f4.tres"),
	KEY_F5: preload("res://assets/input/keyboard/f5.tres"),
	KEY_F6: preload("res://assets/input/keyboard/f6.tres"),
	KEY_F7: preload("res://assets/input/keyboard/f7.tres"),
	KEY_F8: preload("res://assets/input/keyboard/f8.tres"),
	KEY_F9: preload("res://assets/input/keyboard/f9.tres"),
	KEY_F10: preload("res://assets/input/keyboard/f10.tres"),
	KEY_F11: preload("res://assets/input/keyboard/f11.tres"),
	KEY_F12: preload("res://assets/input/keyboard/f12.tres"),
}

const MOUSE_BUTTON_RESOURCES = {
	MOUSE_BUTTON_LEFT: preload("res://assets/input/keyboard/mouse-left.tres"),
	MOUSE_BUTTON_RIGHT: preload("res://assets/input/keyboard/mouse-right.tres"),
	MOUSE_BUTTON_MIDDLE: preload("res://assets/input/keyboard/mouse-middle.tres"),
	MOUSE_BUTTON_WHEEL_DOWN: preload("res://assets/input/keyboard/mouse-wheel-down.tres"),
	MOUSE_BUTTON_WHEEL_UP: preload("res://assets/input/keyboard/mouse-wheel-up.tres"),
	MOUSE_BUTTON_XBUTTON1: 'Mouse button 4',
	MOUSE_BUTTON_XBUTTON2: 'Mouse button 5',
}

const GAMEPAD_BUTTON_RESOURCES = {
	JOY_BUTTON_A: preload("res://assets/input/xbox_buttons/a.tres"),
	JOY_BUTTON_B: preload("res://assets/input/xbox_buttons/b.tres"),
	JOY_BUTTON_X: preload("res://assets/input/xbox_buttons/x.tres"),
	JOY_BUTTON_Y: preload("res://assets/input/xbox_buttons/y.tres"),
	JOY_BUTTON_DPAD_UP: preload("res://assets/input/xbox_buttons/d-pad-up.tres"),
	JOY_BUTTON_DPAD_DOWN: preload("res://assets/input/xbox_buttons/d-pad-down.tres"),
	JOY_BUTTON_DPAD_LEFT: preload("res://assets/input/xbox_buttons/d-pad-left.tres"),
	JOY_BUTTON_DPAD_RIGHT: preload("res://assets/input/xbox_buttons/d-pad-right.tres"),
	JOY_BUTTON_LEFT_SHOULDER: preload("res://assets/input/xbox_buttons/lb.tres"),
	JOY_BUTTON_RIGHT_SHOULDER: preload("res://assets/input/xbox_buttons/rb.tres"),
	JOY_BUTTON_LEFT_STICK: preload("res://assets/input/xbox_buttons/l3.tres"),
	JOY_BUTTON_RIGHT_STICK: preload("res://assets/input/xbox_buttons/r3.tres"),
	JOY_BUTTON_BACK: preload("res://assets/input/xbox_buttons/select.tres"),
	JOY_BUTTON_START: preload("res://assets/input/xbox_buttons/start.tres"),
}

const XBOX_BUTTON_RESOURCES = {
	JOY_BUTTON_A: preload("res://assets/input/xbox_buttons/a.tres"),
	JOY_BUTTON_B: preload("res://assets/input/xbox_buttons/b.tres"),
	JOY_BUTTON_X: preload("res://assets/input/xbox_buttons/x.tres"),
	JOY_BUTTON_Y: preload("res://assets/input/xbox_buttons/y.tres"),
	JOY_BUTTON_DPAD_UP: preload("res://assets/input/xbox_buttons/d-pad-up.tres"),
	JOY_BUTTON_DPAD_DOWN: preload("res://assets/input/xbox_buttons/d-pad-down.tres"),
	JOY_BUTTON_DPAD_LEFT: preload("res://assets/input/xbox_buttons/d-pad-left.tres"),
	JOY_BUTTON_DPAD_RIGHT: preload("res://assets/input/xbox_buttons/d-pad-right.tres"),
	JOY_BUTTON_LEFT_SHOULDER: preload("res://assets/input/xbox_buttons/lb.tres"),
	JOY_BUTTON_RIGHT_SHOULDER: preload("res://assets/input/xbox_buttons/rb.tres"),
	JOY_BUTTON_LEFT_STICK: preload("res://assets/input/xbox_buttons/l3.tres"),
	JOY_BUTTON_RIGHT_STICK: preload("res://assets/input/xbox_buttons/r3.tres"),
	JOY_BUTTON_BACK: preload("res://assets/input/xbox_buttons/select.tres"),
	JOY_BUTTON_START: preload("res://assets/input/xbox_buttons/start.tres"),
}

const SONY_BUTTON_RESOURCES = {
	JOY_BUTTON_A: preload("res://assets/input/playstation_buttons/cross.tres"),
	JOY_BUTTON_B: preload("res://assets/input/playstation_buttons/circle.tres"),
	JOY_BUTTON_X: preload("res://assets/input/playstation_buttons/square.tres"),
	JOY_BUTTON_Y: preload("res://assets/input/playstation_buttons/triangle.tres"),
	JOY_BUTTON_DPAD_UP: preload("res://assets/input/playstation_buttons/d-pad-up.tres"),
	JOY_BUTTON_DPAD_DOWN: preload("res://assets/input/playstation_buttons/d-pad-down.tres"),
	JOY_BUTTON_DPAD_LEFT: preload("res://assets/input/playstation_buttons/d-pad-left.tres"),
	JOY_BUTTON_DPAD_RIGHT: preload("res://assets/input/playstation_buttons/d-pad-right.tres"),
	JOY_BUTTON_LEFT_SHOULDER: preload("res://assets/input/playstation_buttons/l1.tres"),
	JOY_BUTTON_RIGHT_SHOULDER: preload("res://assets/input/playstation_buttons/r1.tres"),
	JOY_BUTTON_LEFT_STICK: preload("res://assets/input/playstation_buttons/l3.tres"),
	JOY_BUTTON_RIGHT_STICK: preload("res://assets/input/playstation_buttons/r3.tres"),
	JOY_BUTTON_BACK: preload("res://assets/input/playstation_buttons/share.tres"),
	JOY_BUTTON_START: preload("res://assets/input/playstation_buttons/options.tres"),
}

const NINTENDO_BUTTON_RESOURCES = {
	JOY_BUTTON_A: preload("res://assets/input/switch_buttons/a.tres"),
	JOY_BUTTON_B: preload("res://assets/input/switch_buttons/b.tres"),
	JOY_BUTTON_X: preload("res://assets/input/switch_buttons/x.tres"),
	JOY_BUTTON_Y: preload("res://assets/input/switch_buttons/y.tres"),
	JOY_BUTTON_DPAD_UP: preload("res://assets/input/switch_buttons/d-pad-up.tres"),
	JOY_BUTTON_DPAD_DOWN: preload("res://assets/input/switch_buttons/d-pad-down.tres"),
	JOY_BUTTON_DPAD_LEFT: preload("res://assets/input/switch_buttons/d-pad-left.tres"),
	JOY_BUTTON_DPAD_RIGHT: preload("res://assets/input/switch_buttons/d-pad-right.tres"),
	JOY_BUTTON_LEFT_SHOULDER: preload("res://assets/input/switch_buttons/l.tres"),
	JOY_BUTTON_RIGHT_SHOULDER: preload("res://assets/input/switch_buttons/r.tres"),
	JOY_BUTTON_LEFT_STICK: preload("res://assets/input/switch_buttons/l3.tres"),
	JOY_BUTTON_RIGHT_STICK: preload("res://assets/input/switch_buttons/r3.tres"),
	JOY_BUTTON_BACK: preload("res://assets/input/switch_buttons/minus.tres"),
	JOY_BUTTON_START: preload("res://assets/input/switch_buttons/plus.tres"),
}

const GAMEPAD_AXIS_RESOURCES = {
	JOY_AXIS_LEFT_X:
	{
		"negative": preload("res://assets/input/xbox_buttons/l-stick-left.tres"),
		"generic": preload("res://assets/input/xbox_buttons/l-stick-x-axis.tres"),
		"positive": preload("res://assets/input/xbox_buttons/l-stick-right.tres"),
	},
	JOY_AXIS_LEFT_Y:
	{
		"negative": preload("res://assets/input/xbox_buttons/l-stick-up.tres"),
		"generic": preload("res://assets/input/xbox_buttons/l-stick-y-axis.tres"),
		"positive": preload("res://assets/input/xbox_buttons/l-stick-down.tres"),
	},
	JOY_AXIS_RIGHT_X:
	{
		"negative": preload("res://assets/input/xbox_buttons/r-stick-left.tres"),
		"generic": preload("res://assets/input/xbox_buttons/r-stick-x-axis.tres"),
		"positive": preload("res://assets/input/xbox_buttons/r-stick-right.tres"),
	},
	JOY_AXIS_RIGHT_Y:
	{
		"negative": preload("res://assets/input/xbox_buttons/r-stick-up.tres"),
		"generic": preload("res://assets/input/xbox_buttons/r-stick-y-axis.tres"),
		"positive": preload("res://assets/input/xbox_buttons/r-stick-down.tres"),
	},
	JOY_AXIS_TRIGGER_LEFT:
	{
		"generic": preload("res://assets/input/xbox_buttons/lt.tres"),
	},
	JOY_AXIS_TRIGGER_RIGHT:
	{
		"generic": preload("res://assets/input/xbox_buttons/rt.tres"),
	},
}

const XBOX_AXIS_RESOURCES = {
	JOY_AXIS_LEFT_X:
	{
		"negative": preload("res://assets/input/xbox_buttons/l-stick-left.tres"),
		"generic": preload("res://assets/input/xbox_buttons/l-stick-x-axis.tres"),
		"positive": preload("res://assets/input/xbox_buttons/l-stick-right.tres"),
	},
	JOY_AXIS_LEFT_Y:
	{
		"negative": preload("res://assets/input/xbox_buttons/l-stick-up.tres"),
		"generic": preload("res://assets/input/xbox_buttons/l-stick-y-axis.tres"),
		"positive": preload("res://assets/input/xbox_buttons/l-stick-down.tres"),
	},
	JOY_AXIS_RIGHT_X:
	{
		"negative": preload("res://assets/input/xbox_buttons/r-stick-left.tres"),
		"generic": preload("res://assets/input/xbox_buttons/r-stick-x-axis.tres"),
		"positive": preload("res://assets/input/xbox_buttons/r-stick-right.tres"),
	},
	JOY_AXIS_RIGHT_Y:
	{
		"negative": preload("res://assets/input/xbox_buttons/r-stick-up.tres"),
		"generic": preload("res://assets/input/xbox_buttons/r-stick-y-axis.tres"),
		"positive": preload("res://assets/input/xbox_buttons/r-stick-down.tres"),
	},
	JOY_AXIS_TRIGGER_LEFT:
	{
		"generic": preload("res://assets/input/xbox_buttons/lt.tres"),
	},
	JOY_AXIS_TRIGGER_RIGHT:
	{
		"generic": preload("res://assets/input/xbox_buttons/rt.tres"),
	},
}

const SONY_AXIS_RESOURCES = {
	JOY_AXIS_LEFT_X:
	{
		"negative": preload("res://assets/input/playstation_buttons/l-stick-left.tres"),
		"generic": preload("res://assets/input/playstation_buttons/l-stick-x-axis.tres"),
		"positive": preload("res://assets/input/playstation_buttons/l-stick-right.tres"),
	},
	JOY_AXIS_LEFT_Y:
	{
		"negative": preload("res://assets/input/playstation_buttons/l-stick-up.tres"),
		"generic": preload("res://assets/input/playstation_buttons/l-stick-y-axis.tres"),
		"positive": preload("res://assets/input/playstation_buttons/l-stick-down.tres"),
	},
	JOY_AXIS_RIGHT_X:
	{
		"negative": preload("res://assets/input/playstation_buttons/r-stick-left.tres"),
		"generic": preload("res://assets/input/playstation_buttons/r-stick-x-axis.tres"),
		"positive": preload("res://assets/input/playstation_buttons/r-stick-right.tres"),
	},
	JOY_AXIS_RIGHT_Y:
	{
		"negative": preload("res://assets/input/playstation_buttons/r-stick-up.tres"),
		"generic": preload("res://assets/input/playstation_buttons/r-stick-y-axis.tres"),
		"positive": preload("res://assets/input/playstation_buttons/r-stick-down.tres"),
	},
	JOY_AXIS_TRIGGER_LEFT:
	{
		"generic": preload("res://assets/input/playstation_buttons/l2.tres"),
	},
	JOY_AXIS_TRIGGER_RIGHT:
	{
		"generic": preload("res://assets/input/playstation_buttons/r2.tres"),
	},
}

const NINTENDO_AXIS_RESOURCES = {
	JOY_AXIS_LEFT_X:
	{
		"negative": preload("res://assets/input/switch_buttons/l-stick-left.tres"),
		"generic": preload("res://assets/input/switch_buttons/l-stick-x-axis.tres"),
		"positive": preload("res://assets/input/switch_buttons/l-stick-right.tres"),
	},
	JOY_AXIS_LEFT_Y:
	{
		"negative": preload("res://assets/input/switch_buttons/l-stick-up.tres"),
		"generic": preload("res://assets/input/switch_buttons/l-stick-y-axis.tres"),
		"positive": preload("res://assets/input/switch_buttons/l-stick-down.tres"),
	},
	JOY_AXIS_RIGHT_X:
	{
		"negative": preload("res://assets/input/switch_buttons/r-stick-left.tres"),
		"generic": preload("res://assets/input/switch_buttons/r-stick-x-axis.tres"),
		"positive": preload("res://assets/input/switch_buttons/r-stick-right.tres"),
	},
	JOY_AXIS_RIGHT_Y:
	{
		"negative": preload("res://assets/input/switch_buttons/r-stick-up.tres"),
		"generic": preload("res://assets/input/switch_buttons/r-stick-y-axis.tres"),
		"positive": preload("res://assets/input/switch_buttons/r-stick-down.tres"),
	},
	JOY_AXIS_TRIGGER_LEFT:
	{
		"generic": preload("res://assets/input/switch_buttons/zl.tres"),
	},
	JOY_AXIS_TRIGGER_RIGHT:
	{
		"generic": preload("res://assets/input/switch_buttons/zr.tres"),
	},
}
