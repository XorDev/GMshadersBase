///@description

obj_control.target = !obj_control.target;
if (obj_control.target)
{
	obj_control.target_x = x+sprite_width/2;
	obj_control.target_y = y+sprite_height/2;
	obj_control.target_zoom = 0.75;
}