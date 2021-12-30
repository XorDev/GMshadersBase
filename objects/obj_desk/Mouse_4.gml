///@desc

obj_camera.target = !obj_camera.target;
if (obj_camera.target)
{
	obj_camera.target_x = x+sprite_width/2;
	obj_camera.target_y = y+sprite_height/2;
	obj_camera.target_zoom = 0.5;
}