///@description

image_speed = 0;

toggle = false;
flip = false;

var _layer = layer_get_id("Interior");
layer_enable_fx(_layer, toggle);
	
var _layer = layer_get_id("Instances");
layer_enable_fx(_layer, toggle);
