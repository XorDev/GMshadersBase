///description Saturation

var _rows = ds_list_size(shaders);
if !surface_exists(surf) surf = surface_create(w, h);


for(var j = 0; j<2; j++)
{
	var _j = umod(floor(scroll) + j, _rows);
	var _n = array_length(shaders[|_j]);
	var _h = floor(window_mouse_get_x()/w*_n);
	
	for(var i = 0; i<_n; i++)
	{
		weight[|_j][i] = weight[|_j][i]*.9+.1*(1+(i==_h));
	}

	//weights
	var _ls = array_length(weight[|_j]);
	var _lw = 1,_cw = 1, _nw = weight[|_j][0];

	for(var i = 0; i<_ls; i++)
	{
		surface_set_target(surf);
		if (i<_n)
		{
			var _shd = shaders[|_j][i];
	
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
				
				case shd_brightness:
				shader_set_uniform_f(u_contrast, 2);
				shader_set_uniform_f(u_brightness, 1);
				break;
			}
		}
		draw_surface(application_surface,0,0);

		surface_reset_target();
		shader_reset();
	
		//gpu_set_blendmode(bm_add);
		_lw = _cw;
		_cw = _nw;
		_nw = i+1<_n?weight[|_j][i+1]:1;
	
		var _x = lerp(0, w*(i+(_lw-_cw)/_n)/_n, 1);//
		var _y = h*(umod(scroll-_j+1,_rows)-1);
		var _w = lerp(w, w*(1+_cw)/_n, 1);
		draw_surface_part(surf, _x, _y, _w, h, _x, _y);
		draw_set_color(#f4ca32);
		draw_set_font(_cw>1.5? fnt_title2 : fnt_title)
	
		draw_set_valign(fa_center);
		draw_set_alpha(_cw/2);
	
		gpu_set_blendmode(bm_normal);
	
		var _s = 1.5-abs(_cw-1.5);
		_x = w*(i+(_lw-1)/_n)/_n+8
		draw_text_transformed(_x, _y+16, i<_n? title[|_j][i]: "Default", _s, _s, 0);
		draw_set_alpha(1);
	}
}
