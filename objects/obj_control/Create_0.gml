///@description Initialize camera variables

//window_set_fullscreen(true);

//Unsigned modulo
function umod(x,y)
{
	return x-floor(x/y)*y;
}

menu = 1;
menu_target = 1;

//Toggle if targeting an object.
target = false;
//Target position
target_x = 0;
target_y = 0;
//Target zoom level
target_zoom = 1;
//Current zoom
zoom = target_zoom;

application_surface_draw_enable(false);
draw_set_font(fnt_title);

text_color = #f4ca32;
text_shadow = merge_color(#f4ca32, 0, 0.35);

//Surface resolution
w = 1440;
h = 810;

scroll = 0;
scroll_target = 0;

//w = display_get_width();
//h = display_get_height();
surface_resize(application_surface, w, h);

demo_init();
var _color_basics = demo_add_row("Color Basics");
var _extended_colors = demo_add_row("Extended Colors");

demo_add_shader(_color_basics, shd_invert, "Invert");
demo_add_shader(_color_basics, shd_saturation, "Saturation");
demo_add_shader(_color_basics, shd_tone, "Tone");

demo_add_shader(_extended_colors, shd_brightness, "Brightness");
demo_add_shader(_extended_colors, shd_hue, "Hue");
demo_add_shader(_extended_colors, shd_lut, "LUT");

surf = -1;

u_saturation = shader_get_uniform(shd_saturation, "u_saturation");

u_tone = shader_get_uniform(shd_tone, "u_tone");

u_hue_shift = shader_get_uniform(shd_hue, "u_hue_shift");
u_h_saturation = shader_get_uniform(shd_hue, "u_saturation");

u_intensity = shader_get_uniform(shd_lut, "u_intensity");
u_LUT = shader_get_sampler_index(shd_lut, "u_LUT");
t_LUT = sprite_get_texture(spr_lut_tension_green, 0);

u_contrast = shader_get_uniform(shd_brightness, "u_contrast");
u_brightness = shader_get_uniform(shd_brightness, "u_brightness");

#region Gleb

shader_params = { // Temporary.
	saturation: {
		amount: 2,
	},
	tone: {
		color: #FFBF66,
		amount: 0,
	},
	hue: {
		saturation: 1,
		shift: 0.4,
	},
	lut: {
		intensity: 1,
	},
	brightness: {
		contrast: 2,
		brightness: 1,
	},
};
modes = {
	arr: ds_list_to_array(category),
	index: 0,
};
lut = {}; with (lut) { // Textures: https://positlabs.github.io/spark-lut-patch/s
	Texture = function(_name, _sprite) constructor {
		name = _name;
		sprite = _sprite;
	};
	
	arr = [
		new Texture("Neutral",			spr_lut_neutral),
		new Texture("Tension Green",	spr_lut_tension_green),
		new Texture("Moonlight",		spr_lut_moonlight),
		new Texture("Late Sunset",		spr_lut_late_sunset),
		new Texture("Edgy Amber",		spr_lut_edgy_amber),
		new Texture("Solarize",			spr_lut_solarize),
	];
	n = array_length(arr);
	index = 1;
	
	change = function(_i) {
		index = _i;
		obj_control.t_LUT = sprite_get_texture(arr[index].sprite, 0);
	};
	tooltip = function(_i) {
		if (imgui_item_hovered()) {
			imgui_tooltip_sprite(arr[_i].sprite, 0, 0.25);	
		}	
	}
};

imguier = new ImGuiWindowNoClose("Parameters", true)
.set_begin(function() {
	imgui_window_pos(8, 8);
	imgui_window_size(231, 116, EImGui_Cond.Once);
	flags = EImGui_WindowFlags.AlwaysAutoResize;
})
.set_update(function() {
	static _mode = function() {
		static _dropdown = function() {
			imgui_dropdown("Mode", modes.index, modes.arr, function(_val) {
				scroll_target = round(scroll - ((_val == 0) ? -1 : 1));
			});
		};
		static _buttons = function() {
			static _button = function(_name, _dir) {
				static _tooltip = function(_dir) {
					if (imgui_item_hovered()) {
						var _title = modes.arr[wrap(modes.index + _dir, 0, array_length(modes.arr) - 1)];
						imgui_tooltip(_title);
					}
				};
				
				var _new_scroll_target = round(scroll - _dir);
				
				if (imgui_button(_name)) scroll_target = _new_scroll_target;
				_tooltip(_dir);
			};
			
			_button("<", -1);
			imgui_same_line();
			_button(">", +1);
		};
		
		_dropdown();
		imgui_same_line();
		_buttons();
	};
	static _params = function() {
		static _basic_colors = function() {
			static _saturation = function() {
				imgui_tree_with("Saturation", saturation, function() {
					amount = imgui_slider_f("Amount", amount, 0, 5, 2);
				});	
			};
			static _tone = function() {
				imgui_tree_with("Tone", tone, function() {
					color = imgui_color_edit("Color", color);
					amount = imgui_slider_f("Amount", amount, 0, 2, 2);
				});
			};
		
			_saturation();
			_tone();
		};
		static _colors_extended = function() {
			static _brightness = function() {
				imgui_tree_with("Brightness", brightness, function() {
					contrast = imgui_slider_f("Contrast", contrast, 0, 2);
					brightness = imgui_slider_f("Brightness", brightness, 0, 2);
				});
			};
			static _hue = function() {
				imgui_tree_with("Hue", hue, function() {
					saturation = imgui_slider_f("Saturation", saturation, 0, 2);
					shift = imgui_slider_f("Shift", shift, 0, 2);
				});
			};
			static _lut = function() {
				imgui_tree_with("LUT", lut, function() {
					static _texture = function() {
						static _dropdown = function() {
							imgui_dropdown_ext("Texture", arr[index].name, function() {
								static _selectable = function(_texture, _i) {
									if (imgui_selectable(_texture.name,,, (_i == index))) {
										change(_i);	
									}
								};
							
								for (var _i = 0; _i < n; _i++) {
									var _texture = arr[_i];
									_selectable(_texture, _i);
									tooltip(_i);
								}
							});
							tooltip(index);
						};
						static _buttons = function() {
							static _button = function(_name, _dir) {
								static _tooltip = function(_dir) {
									if (imgui_item_hovered()) imgui_tooltip_ext(function(_dir) {
										var _texture = arr[wrap(index + _dir, 0, n - 1)]
										imgui_text(_texture.name);
										imgui_separator();
										imgui_sprite(_texture.sprite,, 0.25);
									}, _dir);
								};
				
								if (imgui_button(_name)) {
									index = wrap(index + _dir, 0, n - 1);
									change(index);
								}
								_tooltip(_dir);
							};
			
							_button("<", -1);
							imgui_same_line();
							_button(">", +1);
						};
						
						with (obj_control.lut) {
							_dropdown();
							imgui_same_line();
							_buttons();
						}
					};
					
					intensity = imgui_slider_f("Intensity", intensity, 0, 2);
					_texture();
				});
			};
		
			_brightness();
			_hue();
			_lut();
		};
			
		static _params = [
			_basic_colors, 
			_colors_extended
		];
		
		var _index = modes.index;
		with (shader_params) {
			_params[_index]();
		}
	};
	
	imgui_item_width(120);
	
	with (owner) {
		modes.index = umod(scroll_target, 2);
		_mode();
		imgui_separator();
		_params();
	}
});

imgui_init(-15000);
imgui_style_var(EImGui_StyleVar.FrameBorderSize, 1);

#endregion
