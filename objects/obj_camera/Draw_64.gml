///description Saturation

shader_set(shd_tone);

shader_set_uniform_f(u_tone, 1.0, 0.75, 0.4, keyboard_check(vk_space));
// dcos(get_timer()/50000)*0.5+0.5);
draw_surface(application_surface, 0, 0);

shader_reset();