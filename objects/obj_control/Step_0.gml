///@description Camera movement

imguier.update();

var _scroll = mouse_wheel_up()-mouse_wheel_down();
if (_scroll != 0) scroll_target = round(scroll+_scroll);
scroll = lerp(scroll, scroll_target, .1);
menu = lerp(menu, menu_target, 0.1);

/*
if (menu_target)
{
	window_set_cursor(cr_handpoint);
	
	if mouse_check_button(mb_left) menu_target = false;
}
*/

//If there is no target, follow the mouse
if (target == false)
{
	target_x = mouse_x;
	target_y = mouse_y;
	target_zoom = 1;
}
//Zoom in
zoom = lerp(zoom, target_zoom, .03);

var _border,_view_w,_view_h;
//Scroll border radius
_border = 80*zoom;
//View size
_view_w = 240*zoom;
_view_h = 135*zoom;

//Difference from view position and the target position (with border factoring)
var _delta_x,_delta_y;
_delta_x = max(abs(x-target_x)-_view_w+_border,0)*sign(x-target_x)*!menu;
_delta_y = max(abs(y-target_y)-_view_h+_border,0)*sign(y-target_y)*!menu;

//Move toward the target with no border
if (target == true)
{
	_delta_x = (x-target_x);
	_delta_y = (y-target_y);
}

//Smoothly move the camera position
x = clamp(x - .03*_delta_x, _view_w, room_width-_view_w);
y = clamp(y - .03*_delta_y, _view_h, room_height-_view_h);

//Update camera view
camera_set_view_pos (view_camera[0], x-_view_w, y-_view_h);
camera_set_view_size(view_camera[0], _view_w*2, _view_h*2);

//Compute parallax layers
var	_layer_id = layer_get_id("Background0");
layer_x(_layer_id,(x-240)*1.0);
layer_y(_layer_id,(y-135)*1.0);

var _layer_id = layer_get_id("Background1");
layer_x(_layer_id,(x-240)*0.8);
layer_y(_layer_id,(y-135)*0.8);

var _layer_id = layer_get_id("Background2");
layer_x(_layer_id,(x-240)*0.6);
layer_y(_layer_id,(y-135)*0.6);

var _layer_id = layer_get_id("Background3");
layer_x(_layer_id,(x-240)*0.4);
layer_y(_layer_id,(y-135)*0.4);

var _layer_id = layer_get_id("Background4");
layer_x(_layer_id,(x-240)*0.2);
layer_y(_layer_id,(y-135)*0.2);
