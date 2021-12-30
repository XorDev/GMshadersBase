///@desc

if !target
{
	target_x = mouse_x;
	target_y = mouse_y;
	target_zoom = 1;
}

zoom = lerp(zoom, target_zoom, .03);

var _border,_view_w,_view_h,_view_x,_view_y;
_border = 40;
_view_w = 240*zoom;
_view_h = 135*zoom;
_view_x = x+_view_w;
_view_y = y+_view_h;


x = clamp(_view_x-_view_w-.03*max(abs(_view_x-target_x)-_view_w+_border,0)*sign(_view_x-target_x), 0, room_width-_view_w*2);
y = clamp(_view_y-_view_h-.03*max(abs(_view_y-target_y)-_view_h+_border,0)*sign(_view_y-target_y), 0, room_height-_view_h*2);

var	_layer_id = layer_get_id("Background0");
layer_x(_layer_id,(x-_view_w)*1.0);
layer_y(_layer_id,(y-_view_h)*1.0);

var _layer_id = layer_get_id("Background1");
layer_x(_layer_id,(x-_view_w)*.75);
layer_y(_layer_id,(y-_view_h)*.75);

var _layer_id = layer_get_id("Background2");
layer_x(_layer_id,(x-_view_w)*.50);
layer_y(_layer_id,(y-_view_h)*.50);

var _layer_id = layer_get_id("Background3");
layer_x(_layer_id,(x-_view_w)*.25);
layer_y(_layer_id,(y-_view_h)*.25);

camera_set_view_pos (view_camera[0], x, y);
camera_set_view_size(view_camera[0], _view_w*2, _view_h*2);

window_set_cursor(cr_default);