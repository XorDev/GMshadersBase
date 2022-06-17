///@description Initialize camera variables

//window_set_fullscreen(true);


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

//Surface resolution
w = 1440;
h = 810;

//w = display_get_width();
//h = display_get_height();
surface_resize(application_surface, w, h);

weight = ds_list_create();
ds_list_add(weight,1,1,1,1);

shader_count = 4;
shaders = [shd_invert, shd_saturation, shd_tone, shd_lut, shd_hue]
title = ["Invert", "Saturation", "Tone", "LUT", "Hue"];
surf = -1;

u_saturation = shader_get_uniform(shd_saturation, "u_saturation");
u_tone = shader_get_uniform(shd_tone, "u_tone");
u_hue_shift = shader_get_uniform(shd_hue, "u_hue_shift");
u_h_saturation = shader_get_uniform(shd_hue, "u_saturation");
u_intensity = shader_get_uniform(shd_lut, "u_intensity");
u_LUT = shader_get_sampler_index(shd_lut, "u_LUT");
t_LUT = sprite_get_texture(spr_lut, 0);