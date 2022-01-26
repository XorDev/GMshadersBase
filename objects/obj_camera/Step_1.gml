///@description

if !target
{
	target_x = mouse_x;
	target_y = mouse_y;
	target_zoom = 1;
}

zoom = lerp(zoom, target_zoom, .03);

var _border,_view_w,_view_h,_view_x,_view_y;
_border = 80*zoom;
_view_w = 240*zoom;
_view_h = 135*zoom;
_view_x = x;
_view_y = y;

var _delta_x,_delta_y;
_delta_x = max(abs(_view_x-target_x)-_view_w+_border,0)*sign(_view_x-target_x);
_delta_y = max(abs(_view_y-target_y)-_view_h+_border,0)*sign(_view_y-target_y);

if target
{
	_delta_x = (_view_x-target_x);
	_delta_y = (_view_y-target_y);
}

x = clamp(_view_x - .03*_delta_x, _view_w, room_width-_view_w);
y = clamp(_view_y - .03*_delta_y, _view_h, room_height-_view_h);

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

camera_set_view_pos (view_camera[0], x-_view_w, y-_view_h);
camera_set_view_size(view_camera[0], _view_w*2, _view_h*2);