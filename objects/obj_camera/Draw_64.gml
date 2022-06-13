///description Saturation

var _h = floor(window_mouse_get_x()/w*4);

if !surface_exists(surf) surf = surface_create(w, h);

for(var i = 0; i<shader_count; i++)
{
	ds_list_set(weight, i, weight[|i]*.9+.1*(1+(i==_h)));
}

//weights
var _lw = 1,_cw = 1, _nw = weight[|0];
for(var i = 0; i<4; i++)
{
	surface_set_target(surf);
	if (i<shader_count)
	{
		var _shd = shaders[i];
	
		shader_set(_shd);
		draw_clear(c_black);
	
		switch(_shd)
		{
			case shd_saturation:
			shader_set_uniform_f(u_saturation, 2);
			break;
		
			case shd_tone:
			shader_set_uniform_f(u_tone, 1.0, 0.75, 0.4, 0);
			break;
		
			case shd_hue:
			shader_set_uniform_f(u_h_saturation, 1);
			shader_set_uniform_f(u_hue_shift, 0.2);
			break;
			
			case shd_lut:
			shader_set_uniform_f(u_intensity, 1);
			texture_set_stage(u_LUT, t_LUT);
			break;
		}
	}
	draw_surface(application_surface,0,0);

	surface_reset_target();
	shader_reset();
	
	_lw = _cw;
	_cw = _nw;
	_nw = i+1<shader_count?weight[|i+1]:1;
	
	var _x = lerp(0, w*(i+(_lw-_cw)/4)/4, 1);
	var _w = lerp(w, w*(1+_cw)/4, 1);
	draw_surface_part(surf, _x, 0, _w, h, _x, 0);
	draw_set_color(#f4ca32);
	draw_set_font(_cw>1.5? fnt_title2 : fnt_title)
	
	draw_set_valign(fa_center);
	draw_set_alpha(_cw/2);
	
	var _s = 1.5-abs(_cw-1.5);
	_x = w*(i+(_lw-1)/4)/4+8
	draw_text_transformed(_x, 16, i<shader_count? title[i]: "Default", _s, _s, 0);
	draw_set_alpha(1);
}
