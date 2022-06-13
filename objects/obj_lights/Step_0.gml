///@description

if (flip != toggle)
{
	toggle = flip;
	
	//var _shader = toggle? shd_dim: -1;
	
	var _layer = layer_get_id("Interior");
	layer_enable_fx(_layer, toggle);
	
	var _layer = layer_get_id("Instances");
	layer_enable_fx(_layer, toggle);
}