///@description Initialize camera variables

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

u_saturation = shader_get_uniform(shd_saturation, "u_saturation");
u_invert = shader_get_uniform(shd_invert, "u_invert");
u_tone = shader_get_uniform(shd_tone, "u_tone");