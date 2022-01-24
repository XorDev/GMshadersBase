///@desc

if !target
{
	target_x = window_mouse_get_x()/2+x;//mouse_x;
	target_y =  window_mouse_get_y()/2+y;//mouse_y;
	target_zoom = 1;
}

zoom = lerp(zoom, target_zoom, .03);

var _border,_view_w,_view_h,_view_x,_view_y;
_border = 40;
_view_w = 240*zoom;
_view_h = 135*zoom;
_view_x = x+_view_w;
_view_y = y+_view_h;


x = clamp(_view_x-_view_w - .03*max(abs(_view_x-target_x)-_view_w+_border,0)*sign(_view_x-target_x), 0, room_width-_view_w*2);
y = clamp(_view_y-_view_h - .03*max(abs(_view_y-target_y)-_view_h+_border,0)*sign(_view_y-target_y), 0, room_height-_view_h*2);

var	_layer_id = layer_get_id("Background0");
layer_x(_layer_id,(x)*1.0);
layer_y(_layer_id,(y)*1.0);

var _layer_id = layer_get_id("Background1");
layer_x(_layer_id,(x)*.75);
layer_y(_layer_id,(y)*.75);

var _layer_id = layer_get_id("Background2");
layer_x(_layer_id,(x)*.50);
layer_y(_layer_id,(y)*.50);

var _layer_id = layer_get_id("Background3");
layer_x(_layer_id,(x)*.25);
layer_y(_layer_id,(y)*.25);


//camera_set_view_mat(view_camera[0], matrix_build_lookat(_view_x,_view_y,-1400, _view_x,_view_y,0, 0,1,0));
//camera_set_proj_mat(view_camera[0], matrix_build_projection_perspective_fov(10,_view_w/_view_h,0.1,10000));
camera_set_view_pos (view_camera[0], x, y);
camera_set_view_size(view_camera[0], _view_w*2, _view_h*2);