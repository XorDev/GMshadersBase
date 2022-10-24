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
t_LUT = sprite_get_texture(spr_lut, 0);