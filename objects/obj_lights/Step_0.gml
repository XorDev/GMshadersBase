///@desc

if position_meeting(mouse_x, mouse_y, self) window_set_cursor(cr_handpoint);

if (flip != toggle)
{
	toggle = flip;
	var _layer = layer_get_id("Inside_sprites");
	var _shader = toggle? shd_dim: -1;
	layer_shader(_layer, _shader);
	var _layer = layer_get_id("Instances");

	layer_shader(_layer, _shader);
}