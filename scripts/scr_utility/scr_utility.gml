
function noop(){}
function return_true() { return true; }
function return_false() { return false; }
function wrap(_val, _min, _max) {
	return ((_val > _max) ? _min : ((_val < _min) ? _max : _val));
}
function remap(_val, _from1, _to1, _from2, _to2) {
	return (_from2 + ((_to2 - _from2) / (_to1 - _from1)) * (_val - _from1));
}
function ds_list_to_array(_list) {
	var _n = ds_list_size(_list);
	var _array = array_create(_n);
	for (var _i = 0; _i < _n; _i++) {
		_array[_i] = _list[| _i];
	}
	return _array;
}


function ImGuiWindow(_title = "", _enabled = true, _init_cb = noop) constructor {
	/// @func ImGuiWindow() constructor
	/// @param {String} [title=empty]
	/// @param {Bool} [on?=true]
	/// @param {Func} [init_callback=noop]
	/// @returns {struct<ImGuiWindow>} self
	
	owner = other;
	title = _title;
	enabled = _enabled;
	flags = 0;
	
	static __begin = noop;
	static __update = noop;
	static __draw = noop;
	static __cleanup = noop;
	static __enabled_checker = return_true;
	
	static set_begin = function(_cb) {
		__begin = method(self, _cb);
		return self;
	};
	static set_update = function(_cb) {
		__update = method(self, _cb);
		return self;
	};
	static set_draw = function(_cb) {
		__draw = method(self, _cb);
		return self;
	};
	static set_cleanup = function(_cb) {
		__cleanup = method(self, _cb);
		return self;
	};
	static set_enabled_checker = function(_cb) {
		__enabled_checker = method(self, _cb);
		return self;
	};
	
	static get_enabled_checker = function() {
		return __enabled_checker;	
	};
	
	static init = function(_cb) {
		method(self, _cb)();
		return self;
	};
	static toggle = function(_enabled = !enabled) {
		if (_enabled) {
			if (__enabled_checker()) {
				enabled = true;	
			}
		}
		else enabled = false;
	};
	static update = function() {
		if (!enabled) return;
		
		__begin();
		enabled = ((imgui_begin(title, enabled, flags)) && (__enabled_checker()));
		__update();
	};
	static draw = function() {
		__draw();
	};
	static cleanup = function() {
		__cleanup();	
	};
	
	method(self, _init_cb)();
}
function ImGuiWindowNoClose(_title = "", _enabled = true, _init_cb = noop) : ImGuiWindow(_title, _enabled, _init_cb) constructor {
	/// @func ImGuiWindowNoClose() constructor
	/// @param {String} [title=empty]
	/// @param {Bool} [on?=true]
	/// @param {Func} [init_callback=noop]
	/// @returns {struct<ImGuiWindowNoClose>} self
	
	static update = function() {
		if (!enabled) return;
		
		__begin();
		imguigml_begin(title, undefined, flags);
		enabled = __enabled_checker();
		__update();
	};
}

function imgui_init(_depth) {
	/// @func imgui_init()
	/// @param {Real} depth
	
	instance_create_depth(0, 0, _depth, imgui);
}
function imgui_toggle(_enabled) {
	/// @func imgui_toggle()
	/// @param {Bool} enabled?
	
	(_enabled ? imguigml_activate : imguigml_deactivate)();
}
function imgui_is_ready() {
	/// @func imgui_is_ready()
	/// @param {Bool} enabled?

	return imguigml_ready();
}
function imgui_begin(_title = "", _open = undefined, _flags = 0) {
	/// @func imgui_begin()
	/// @param {String} [title=""]
	/// @param {Bool} [open=undefined]
	/// @param {Int/Enum<EImGui_WindowFlags>} [flags=0]
	/// @returns {Bool} enabled?
	
	return imguigml_begin(_title, _open, _flags)[1];	
}
function imgui_end() {
	imguigml_end();
}

function imgui_window_pos(_x, _y, _condition = 0, _pivot_x = 0, _pivot_y = 0) {
	/// @func imgui_window_pos()
	/// @param {Real} x
	/// @param {Real} y
	/// @param {Enum<EImGui_Cond>} [condition=0]
	/// @param {Real} [pivot_x=0] 
	/// @param {Real} [pivot_y=0]
	
	imguigml_set_next_window_pos(_x, _y, _condition, _pivot_x, _pivot_y);
}
function imgui_window_size(_x, _y, _condition = 0) {
	/// @func imgui_window_size()
	/// @param {Real} x
	/// @param {Real} y
	/// @param {Enum<EImGui_Cond>} [condition=0]
	
	imguigml_set_next_window_size(_x, _y, _condition);
}
function imgui_window_focus(_title) {
	/// @func imgui_window_focus()
	/// @param {String} title
	
	imguigml_set_window_focus(_title);
}
function imgui_window_focused(_flags = 0) {
	/// @func imgui_window_focused()
	/// @param {Int/Enum<EImGui_FocusedFlags>} [flags=0]
	
	return imguigml_is_window_focused(_flags);
}

function imgui_child(_title, _w, _h, _border = true, _cb, _cb_data = undefined, _flags = 0) {
	/// @func imgui_child()
	/// @param {String} title
	/// @param {Real} width
	/// @param {Real} height
	/// @param {Bool} [border=true]
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	/// @param {Int/Enum<EImGui_WindowFlags>} [flags=0]
	
	imguigml_begin_child(_title, _w, _h, _border, _flags);
	_cb(_cb_data);
	imguigml_end_child();
}

function imgui_menu_bar(_cb, _cb_data = undefined) {
	/// @func imgui_menu_bar()
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	
	if (imguigml_begin_menu_bar()) {
		_cb(_cb_data);
		imguigml_end_menu_bar();
	}
}
function imgui_menu(_title, _cb, _cb_data = undefined) {
	/// @func imgui_menu()
	/// @param {String} title
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	
	if (imguigml_begin_menu(_title)) {
		_cb(_cb_data);
		imguigml_end_menu();
	}
}
function imgui_menu_item(_title, _shortcut = "", _cb = noop, _cb_data = undefined, _selected = false, _enabled = true) {
	/// @func imgui_menu_item()
	/// @param {String} title
	/// @param {String} [shortcut=empty]
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	/// @param {Bool} [selected=false]
	/// @param {Bool} [enabled=false]
	
	if (imguigml_menu_item(_title, _shortcut, _selected, _enabled)) {
		_cb(_cb_data);
	}
}
function imgui_menu_item_window(_title, _shortcut = "", _window, _enabled = (_window.get_enabled_checker())()) {
	/// @func imgui_menu_item_window()
	/// @param {String} title
	/// @param {String} [shortcut=empty]
	/// @param {struct<ImGuiWindow>} window
	/// @param {Bool} [enabled=window_enabled_checker_call]
	
	imgui_menu_item(_title, _shortcut, function(_window) {
		_window.toggle();
	}, _window, _window.enabled, _enabled);
}

function imgui_tab_bar(_cb, _cb_data = undefined) {
	/// @func imgui_tab_bar()
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	
	imguigml_begin_tab_bar("MainTab");
	_cb(_cb_data);
	imguigml_end_tab_bar();
}
function imgui_tab_bar_with(_scope, _cb, _cb_data = undefined) {
	/// @func imgui_tab_bar_with()
	/// @param {GMInstanceID/Struct} scope
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	
	imguigml_begin_tab_bar("MainTab");
	method(_scope, _cb)(_cb_data);
	imguigml_end_tab_bar();
}
function imgui_tab_item(_title, _cb, _cb_data = undefined) {
	/// @func imgui_tab_item()
	/// @param {String} title
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	
	var _ret = imguigml_begin_tab_item(_title);
	if (_ret[0])  {
        _cb(_cb_data);
		imguigml_end_tab_item();
	}
}
function imgui_tab_item_with(_title, _scope, _cb, _cb_data = undefined) {
	/// @func imgui_tab_item_with()
	/// @param {String} title
	/// @param {GMInstanceID/Struct} scope
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	
	var _ret = imguigml_begin_tab_item(_title);
	if (_ret[0]) {
        method(_scope, _cb)(_cb_data);
		imguigml_end_tab_item();
	}
}

function imgui_tree(_title, _cb, _cb_data = undefined, _flags = 0) {
	/// @func imgui_tree()
	/// @param {String} title
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	/// @param {Int/Enum<EImGui_TreeNodeFlags>} [flags=0]
	
	if (!imguigml_tree_node_ex(_title, _flags)) return;
	_cb(_cb_data);
	imguigml_tree_pop();
}
function imgui_tree_with(_title, _scope, _cb, _cb_data = undefined, _flags = 0) {
	/// @func imgui_tree_with()
	/// @param {String} title
	/// @param {GMInstanceID/Struct} scope
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	/// @param {Int/Enum<EImGui_TreeNodeFlags>} [flags=0]
	
	if (!imguigml_tree_node_ex(_title, _flags)) return;
	method(_scope, _cb)(_cb_data);
	imguigml_tree_pop();
}
function imgui_header(_title, _cb = noop, _cb_data = undefined, _flags = 0) {
	/// @func imgui_header()
	/// @param {String} title
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	/// @param {Int/Enum<EImGui_TreeNodeFlags>} [flags=0]
	/// @returns {Bool} Whether the header is open (true) or not (false).
	
	if (!imguigml_collapsing_header(_title,, _flags)[0]) return false;
	_cb(_cb_data);
	return true;
}
function imgui_header_with(_title, _scope, _cb, _cb_data = undefined) {
	/// @func imgui_header_with()
	/// @param {String} title
	/// @param {GMInstanceID/Struct} scope
	/// @param {String} title
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	
	if (imguigml_collapsing_header(_title)[0]) {
		method(_scope, _cb)(_cb_data);
	}
}

function imgui_separator() {
	imguigml_separator();	
}
function imgui_same_line() {
	imguigml_same_line();	
}
function imgui_indent(_val) {
	/// @func imgui_indent()
	/// @param {Real} value
	
	imguigml_indent(_val);
}
function imgui_unindent(_val) {
	/// @func imgui_indent()
	/// @param {Real} value
	
	imguigml_unindent(_val);
}

function imgui_slider_i(_title, _val, _val_min, _val_max, _cb = noop, _cb_data = undefined) {
	/// @func imgui_slider_i()
	/// @param {String}	title
	/// @param {Int} value
	/// @param {Int} value_min
	/// @param {Int} value_max
	/// @param {Func} [callback=empty]
	/// @param {Any} [callback_data=undefined]
	/// @returns {Int} Value. Either affected or unaffected by the slider.
	
	var _ret = imguigml_slider_int(_title, _val, _val_min, _val_max);
	if (_ret[0]) {
		_cb(_ret[1], _cb_data);
		return _ret[1];
	}
	return _val;
}
function imgui_slider_i2(_title, _val1, _val2, _val_min, _val_max, _cb = noop, _cb_data = undefined) {
	/// @func imgui_slider_i2()
	/// @param {String}	title
	/// @param {Int} value1
	/// @param {Int} value2
	/// @param {Int} value_min
	/// @param {Int} value_max
	/// @param {Func} [callback=empty]
	/// @param {Any} [callback_data=undefined]
	
	var _ret = imguigml_slider_int2(_title, _val1, _val2, _val_min, _val_max);
	if (_ret[0]) {
		_cb(_ret[1], _ret[2], _cb_data);
	}
}
function imgui_slider_i3(_title, _val1, _val2, _val3, _val_min, _val_max, _cb = noop, _cb_data = undefined) {
	/// @func imgui_slider_i3()
	/// @param {String}	title
	/// @param {Int} value1
	/// @param {Int} value2
	/// @param {Int} value3
	/// @param {Int} value_min
	/// @param {Int} value_max
	/// @param {Func} [callback=empty]
	/// @param {Any} [callback_data=undefined]
	
	var _ret = imguigml_slider_int3(_title, _val1, _val2, _val3, _val_min, _val_max);
	if (_ret[0]) {
		_cb(_ret[1], _ret[2], _ret[3], _cb_data);
	}
}
function imgui_slider_i4(_title, _val1, _val2, _val3, _val4, _val_min, _val_max, _cb = noop, _cb_data = undefined) {
	/// @func imgui_slider_i4()
	/// @param {String}	title
	/// @param {Int} value1
	/// @param {Int} value2
	/// @param {Int} value3
	/// @param {Int} value4
	/// @param {Int} value_min
	/// @param {Int} value_max
	/// @param {Func} [callback=empty]
	/// @param {Any} [callback_data=undefined]
	
	var _ret = imguigml_slider_int4(_title, _val1, _val2, _val3, _val4, _val_min, _val_max);
	if (_ret[0]) {
		_cb(_ret[1], _ret[2], _ret[3], _ret[4], _cb_data);
	}
}
function imgui_slider_f(_title, _val, _val_min, _val_max, _n_decimals = 1, _cb = noop, _cb_data = undefined) {
	/// @func imgui_slider_f()
	/// @param {String}	title
	/// @param {Real} value
	/// @param {Real} value_min
	/// @param {Real} value_max
	/// @param {Int} [n_decimals=1]
	/// @param {Func} [callback=empty]
	/// @param {Any} [callback_data=undefined]
	/// @returns {Real} Value. Either affected or unaffected by the slider.
	
	var _format	= "%." + string(_n_decimals) + "f";
	var _ret = imguigml_slider_float(_title, _val, _val_min, _val_max, _format, EImGui_SliderFlags.AlwaysClamp);
	if (_ret[0]) {
		_cb(_ret[1], _cb_data);
		return _ret[1];
	}
	return _val;
}
function imgui_slider_f2(_title, _val1, _val2, _val_min, _val_max, _n_decimals = 1, _cb, _cb_data = undefined) {
	/// @func imgui_slider_f2()
	/// @param {String}	title
	/// @param {Real} value1
	/// @param {Real} value2
	/// @param {Real} value_min
	/// @param {Real} value_max
	/// @param {Int} [n_decimals=1]
	/// @param {Func} [callback=empty]
	/// @param {Any} [callback_data=undefined]
	
	var _format	= "%." + string(_n_decimals) + "f";
	var _ret = imguigml_slider_float2(_title, _val1, _val2, _val_min, _val_max, _format, EImGui_SliderFlags.AlwaysClamp);
	if (_ret[0]) {
		_cb(_ret[1], _ret[2], _cb_data);
	}
}
function imgui_slider_f3(_title, _val1, _val2, _val3, _val_min, _val_max, _n_decimals = 1, _cb, _cb_data = undefined) {
	/// @func imgui_slider_f3()
	/// @param {String}	title
	/// @param {Real} value1
	/// @param {Real} value2
	/// @param {Real} value3
	/// @param {Real} value_min
	/// @param {Real} value_max
	/// @param {Int} [n_decimals=1]
	/// @param {Func} [callback=empty]
	/// @param {Any} [callback_data=undefined]
	
	var _format	= "%." + string(_n_decimals) + "f";
	var _ret = imguigml_slider_float3(_title, _val1, _val2, _val3, _val_min, _val_max, _format, EImGui_SliderFlags.AlwaysClamp);
	if (_ret[0]) {
		_cb(_ret[1], _ret[2], _ret[3], _cb_data);
	}
}
function imgui_slider_f4(_title, _val1, _val2, _val3, _val4, _val_min, _val_max, _n_decimals = 1, _cb, _cb_data = undefined) {
	/// @func imgui_slider_f4()
	/// @param {String}	title
	/// @param {Real} value1
	/// @param {Real} value2
	/// @param {Real} value3
	/// @param {Real} value4
	/// @param {Real} value_min
	/// @param {Real} value_max
	/// @param {Int} [n_decimals=1]
	/// @param {Func} [callback=empty]
	/// @param {Any} [callback_data=undefined]
	
	var _format	= "%." + string(_n_decimals) + "f";
	var _ret = imguigml_slider_float4(_title, _val1, _val2, _val3, _val4, _val_min, _val_max, _format, EImGui_SliderFlags.AlwaysClamp);
	if (_ret[0]) {
		_cb(_ret[1], _ret[2], _ret[3], _ret[4], _cb_data);
	}
}

function imgui_dropdown(_title, _item, _items, _cb = noop, _cb_data = undefined) {
	/// @func imgui_dropdown()
	/// @param {String} title
	/// @param {Int} item
	/// @param {Array} items
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	/// @param {Int/Enum<EImGui_ComboFlags>} [flags=0]
	
	var _ret = imguigml_combo(_title, _item, _items);
	if (_ret[0]) {
		_cb(_ret[1]);
		return _ret[1];
	}
	return _item;
}	
function imgui_dropdown_ext(_title, _item, _cb = noop, _cb_data = undefined, _flags = 0) {
	/// @func imgui_dropdown_ext()
	/// @param {String} title
	/// @param {Int} item
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	/// @param {Int/Enum<EImGui_ComboFlags>} [flags=0]
	
	if (imguigml_begin_combo(_title, _item, _flags)) {
		_cb(_cb_data);						
		imguigml_end_combo();
	}
}
function imgui_list(_title, _item, _items, _height_in_items = -1, _cb = noop, _cb_data = undefined) {
	/// @func imgui_list()
	/// @param {String} title
	/// @param {Any} item
	/// @param {Array} items
	/// @param {Int} [height_in_items=-1]
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	
	var _list = imguigml_list_box(_title, _item, _items, _height_in_items);
	if (_list[0]) {
		_cb(_list[1], _cb_data);
	}
}
function imgui_list_ext(_title = "", _w, _h, _cb, _cb_data = undefined) {
	/// @func imgui_list_ext()
	/// @param {String} title
	/// @param {Real} width
	/// @param {Real} height
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	
	imguigml_list_box_header(_title, _w, _h);
	_cb(_cb_data);
	imguigml_list_box_footer();
}
function imgui_selectable(_title, _cb = undefined, _cb_data = undefined, _selected = false) {
	/// @func imgui_selectable()
	/// @param {String} title
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	/// @param {Bool} [selected=false]
	/// @retuns {Bool} Whether the Selectable was selected or not.
	
	var _ret = imguigml_selectable(_title, _selected);
	if (_ret[0]) {
		if (_cb != undefined) _cb(_cb_data);
		return true;
	}
	return false;
}

function imgui_input_f(_title, _val, _val_min, _val_max, _step = 0.0, _step_fast = 0.0, _n_decimals = 1, _cb, _cb_data = undefined) {
	/// @func imgui_input_f()
	/// @param {String} title
	/// @param {Real} value
	/// @param {Real} value_min
	/// @param {Real} value_max
	/// @param {Real} [step=0.0]
	/// @param {Real} [step_fast=0.0]
	/// @param {Real} [n_decimals=1]
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	/// @returns {Real} Value. Either affected or unaffected by the slider.
	
	var _ret = imguigml_input_float(_title, _val, _step, _step_fast, _n_decimals)
	if (_ret[0]) {
		_ret[1] = clamp(_ret[1], _val_min, _val_max);
		_cb(_ret[1], _cb_data);
		return _ret[1];
	}
	return _val;
}
function imgui_input_text(_title, _text, _max_length, _cb = noop, _cb_data = undefined) {
	/// @func imgui_input_text()
	/// @param {String} title
	/// @param {String} text
	/// @param {Int} max_length
	/// @param {Func} [callback_data=undefined]
	/// @returns {String} Text. Either affected or unaffected by the slider.
	
	var _ret = imguigml_input_text(_title, _text, _max_length);
	if (_ret[0]) {
		_cb(_ret[1], _cb_data);
		return _ret[1];
	}
	return _text;
}
function imgui_input_text_multi(_title, _text, _max_length, _w, _h) {
	/// @func imgui_input_text()
	/// @param {String} title
	/// @param {String} text
	/// @param {Int} max_length
	/// @param {Func} [callback_data=undefined]
	/// @returns {String} Text. Either affected or unaffected by the slider.
	
	return imguigml_input_text_multiline("", _text, _max_length, _w, _h)[1];
}

function imgui_button(_title, _cb = noop, _cb_data = undefined, _w = 0, _h = 0) {
	/// @func imgui_button()
	/// @param {String} title
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	/// @param {Real} [width=auto]
	/// @param {Real} [height=auto]
	/// @returns {Bool} Whether the button is pressed (true) or not (false).
	
	var _pressed = imguigml_button(_title, _w, _h);
	if (_pressed) {
		_cb(_cb_data);
		return true;	
	}
	return false;
}
function imgui_buttons_same_line() {
	for (var _i = 0; _i < argument_count; _i += 2) {
		var _title = argument[_i];
		var _cb = argument[_i + 1]
		imgui_button(_title, _cb);
		
		if (_i < (argument_count - 2)) {
			imgui_same_line();
		}
	}
}
function imgui_button_sprite(_sprite, _subimg = 0, _cb = noop, _cb_data = undefined, _w = 0, _h = 0, _frame_pad = -1) {
	/// @func imgui_button_sprite()
	/// @param {Asset.GMSprite} sprite
	/// @param {Real} [subimg=0]
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	/// @param {Real} [width=auto]
	/// @param {Real} [height=auto]
	/// @param {Real} [prame_pad=default]
	/// @returns {Bool} Whether the button is pressed (true) or not (false).
	
	var _pressed = imguigml_sprite_button(_sprite, _subimg, _w, _h, _frame_pad);
	if (_pressed) {
		_cb(_cb_data);
		return true;	
	}
	return false;
}

function imgui_checkbox(_title, _val, _cb = noop, _cb_data = undefined) {
	/// @func imgui_checkbox()
	/// @param {String} title
	/// @param {Bool} value
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	/// @returns {Bool} Value. Either affected or unaffected by the checkbox.
	
	var _ret = imguigml_checkbox(_title, _val);
	if (_ret[0]) {
		_cb(_ret[1]);
		return _ret[1];
	}
	return _val;
}
function imgui_radio(_title, _val) {
	/// @func imgui_radio()
	/// @param {String} title
	/// @param {Bool} value
	/// @returns {Bool} Whether the Radio was toggled (true) or not (false).
	
	return imguigml_radio_button(_title, _val);
}
function imgui_radio_bool(_title1, _title2, _val, _same_line = false) {
	/// @func imgui_radio_bool()
	/// @param {Strigng} title1
	/// @param {Strigng} title2
	/// @param {Bool} value
	/// @param {Bool} [same_line?=false]
	/// @returns {Bool} Any of the Radios toggled - appropriate true/false value. Otherwise - starting value.
	
	var _val_new = undefined;
	if (imgui_radio(_title1, _val)) _val_new = true;
	if (_same_line) imgui_same_line();
	if (imgui_radio(_title2, !_val)) _val_new = false;
	return (_val_new ?? _val); 
}
function imgui_text(_string, _color = c_white, _alpha = 1) {
	/// @func imgui_text()
	/// @param {String} string
	/// @param {Constant.GMColor} [color=c_white]
	/// @param {Real} [alpha=1]
	
	var _r = color_get_red(_color) / 255;
	var _b = color_get_blue(_color) / 255;
	var _g = color_get_green(_color) / 255;
	imguigml_text_colored(_r, _g, _b, _alpha, _string);	
}
function imgui_sprite(_sprite, _subimg = 0, _xscale = 1, _yscale = _xscale) {
	/// @func imgui_sprite()
	/// @param {Asset.GMSprite} sprite
	/// @param {Real} [subimg=0]
	/// @param {Real} [xscale=1]
	/// @param {Real} [yscale=xscale]
	
	var _w = sprite_get_width(_sprite) * _xscale;
	var _h = sprite_get_height(_sprite) * _yscale;
	imguigml_sprite(_sprite, _subimg, _w, _h);
}
function imgui_surface(_surf, _xscale = 1, _yscale = _xscale) {
	/// @func imgui_surface()
	/// @param {ID.Surface} surface
	/// @param {Real} [xscale=1]
	/// @param {Real} [yscale=xscale]
	
	var _w = surface_get_width(_surf) * _xscale;
	var _h = surface_get_height(_surf) * _yscale;
	imguigml_surface(_surf, _w, _h);
}
function imgui_color_edit(_title, _color, _cb = noop, _cb_data = undefined) {
	/// @func imgui_color_edit()
	/// @param {String} title
	/// @param {Constant.GMColor} color
	/// @param {Func} [callback=noop]
	/// @param {Any} [callback_data=undefined]
	/// @returns {Constant.GMColor} Color. Either affected or unaffected by the color edit.
	
	var _c = imguigml_color_convert_gml_to_float4(_color, 1);
	var _ret = imguigml_color_edit3(_title, _c[0], _c[1], _c[2]);  
	if (_ret[0]) {
		_c = imguigml_color_convert_float4_to_gml(_ret[1], _ret[2], _ret[3], 1)[0];
		_cb(_c, _cb_data);
		return _c;
	}
	
	return _color;
}

function imgui_tooltip(_title, _cb = undefined, _cb_data = undefined) {
	/// @func imgui_tooltip()
	/// @param {String} title
	/// @param {Func} [callback=undefined]
	/// @param {Any} [callback_data=undefined]
	/// @descr Callback argument given - runs custom tooltip code, otherwise uses the title for a text-based tooltip.
	
	if (_cb == undefined) imguigml_set_tooltip(_title);	
	else {
		imguigml_begin_tooltip();
		_cb(_cb_data);
		imguigml_end_tooltip();
	}
}
function imgui_tooltip_sprite(_sprite, _subimg = 0, _xscale = 1, _yscale = _xscale) {
	/// @func imgui_tooltip_sprite()
	/// @param {Asset.GMSprite} sprite
	/// @param {Real} [subimg=0]
	/// @param {Real} [xscale=1]
	/// @param {Real} [yscale=xscale]
	
	imguigml_begin_tooltip();
	imgui_sprite(_sprite, _subimg, _xscale, _yscale);
	imguigml_end_tooltip();
}
function imgui_tooltip_surface(_surf, _xscale = 1, _yscale = _xscale) {
	/// @func imgui_tooltip_surface()
	/// @param {Asset.GMSprite} sprite
	/// @param {Real} [subimg=0]
	/// @param {Real} [xscale=1]
	/// @param {Real} [yscale=xscale]
	
	imguigml_begin_tooltip();
	imgui_surface(_surf, _xscale, _yscale);
	imguigml_end_tooltip();
}
function imgui_tooltip_ext(_cb, _cb_data = undefined) {
	/// @func imgui_tooltip_ext()
	/// @param {Func} [callback=undefined]
	/// @param {Any} [callback_data=undefined]
	
	imguigml_begin_tooltip();
	_cb(_cb_data);
	imguigml_end_tooltip();	
}
function imgui_qmark(_text) {
	/// @func imgui_qmark()
	/// @param {String} text
	/// @desc Wrapper for a same-line "(?)" ImGui Text and a Tooltip triggered when hovering over the Text.
	
	imgui_same_line();
	imguigml_text_disabled("(?)");
	if (imgui_item_hovered()) {
		imgui_tooltip(_text);	
	}
}

function imgui_popup(_str_id, _cb, _cb_data = undefined) {
	/// @func imgui_popup()
	/// @param {String} string_id
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	
	if (imguigml_begin_popup(_str_id)) {
		_cb(_cb_data);
		imguigml_end_popup();
	}
}
function imgui_popup_open(_str_id) {
	/// @func imgui_popup_open()
	/// @param {String} string_id
	
	imguigml_open_popup(_str_id);		
}
function imgui_popup_is_open(_str_id) {
	/// @func imgui_popup_is_open()
	/// @param {String} string_id
	
	return imguigml_is_popup_open(_str_id);
}
function imgui_popup_modal(_title, _cb, _cb_data, _flags = 0) {
	/// @func imgui_popup_modal()
	/// @param {String} title
	/// @param {Func} callback
	/// @param {Any} [callback_data=undefined]
	/// @param {Int/Enum<EImGui_WindowFlags>} [flags=0]
	
	if (imguigml_begin_popup_modal(_title, true, _flags)) {
		_cb(_cb_data);
		imguigml_end_popup();
	};
}

function imgui_item_width(_w) {	
	/// @func imgui_item_width()
	/// @param {Real} width
	
	imguigml_push_item_width(_w);
}
function imgui_item_hovered(_flags = 0) {
	/// @func imgui_item_hovered()
	/// @param {Int/Enum<EImGui_HoveredFlags>} [flags=0]
	/// @returns {Bool} Whether the latest item is hovered over (true) or not (false).
	
	return imguigml_is_item_hovered(_flags);
}
function imgui_item_hovered_any() {
	/// @func imgui_item_hovered_any()
	/// @returns {Bool} Whether any of the items are hovered over (true) or not (false).
	
	return imguigml_is_any_item_hovered();
}
function imgui_item_clicked(_mb = 0) {
	/// @func imgui_item_clicked()
	/// @param {GMConstant} [mouse_button=mb_left]
	/// @returns {Bool} Whether the latest item is clicked (true) or not (false).
	
	return imguigml_is_item_clicked(_mb);
}
function imgui_item_get_bbox(_bbox_struct = {}) {
	/// @func imgui_item_get_bbox()
	/// @param {Struct} [bbox_struct=new_struct]
	/// @returns {Struct} Bbox struct: { x1, y1, x2, y2 }.
	
	var _p1 = imguigml_get_item_rect_min();
	var _p2 = imguigml_get_item_rect_max();
	
	with (_bbox_struct) {
		x1 = _p1[0];
		y1 = _p1[1];
		x2 = _p2[0];
		y2 = _p2[1];
	}
	
	return _bbox_struct;
}

function imgui_scale_set(_x, _y = _x) {
	/// @func imgui_scale_set()
	/// @param {Real} xscale
	/// @param {Real} [yscale=xscale]
	
	imguigml_set_display_scale(_x, _y);
}
function imgui_style_var(_var, _val) {
	/// @func imgui_style_var()
	/// @param {Enum<EImGui_StyleVar>} variable
	/// @param {Real} value
	
	imguigml_push_style_var(_var, _val);	
}
