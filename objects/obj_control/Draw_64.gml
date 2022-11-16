///description Display shaders

if !surface_exists(surf) surf = surface_create(w, h);

//WIP: Please don't judge me!!

var _p; // [Gleb] Shortcut for 'shader_params.shader...'. Temporary.

for(var j = 0; j<2; j++)
{
	var _j = umod(floor(scroll) + j, rows);
	var _n = ds_list_size(shaders[|_j]);
	var _h = floor(window_mouse_get_x()/w*_n);
	
	for(var i = 0; i<_n; i++)
	{
		weights[|_j][|i] = weights[|_j][|i]*.9+.1*(1+(i==_h));
	}

	//weights
	var _ls = _n;
	var _lw = 1,_cw = 1, _nw = weights[|_j][|0];
	
	for(var i = 0; i<_ls; i++)
	{
		surface_set_target(surf);
		if (i<_n)
		{
			var _shd = shaders[|_j][|i];
	
			shader_set(_shd);
			draw_clear(c_black);
	
			switch(_shd)
			{
				case shd_saturation:
				_p = shader_params.saturation; // [Gleb] Params shortcut. Temporary.
				shader_set_uniform_f(u_saturation, _p.amount);
				break;
				
				case shd_tone:
				_p = shader_params.tone; // [Gleb] Params shortcut. Temporary.
				var _c = _p.color;
				var _r = color_get_red(_c) / 255;
				var _g = color_get_green(_c) / 255;
				var _b = color_get_blue(_c) / 255;
				shader_set_uniform_f(u_tone, _r, _g, _b, _p.amount);
				break;
				
				case shd_hue:
				_p = shader_params.hue; // [Gleb] Params shortcut. Temporary.
				shader_set_uniform_f(u_h_saturation, _p.saturation);
				shader_set_uniform_f(u_hue_shift, _p.shift);
				break;
				
				case shd_lut:
				_p = shader_params.lut; // [Gleb] Params shortcut. Temporary.
				shader_set_uniform_f(u_intensity, _p.intensity);
				texture_set_stage(u_LUT, t_LUT);
				break;
				
				case shd_brightness:
				_p = shader_params.brightness; // [Gleb] Params shortcut. Temporary.
				shader_set_uniform_f(u_contrast, _p.contrast);
				shader_set_uniform_f(u_brightness, _p.brightness);
				break;
			}
		}
		draw_surface(application_surface,0,0);
		
		surface_reset_target();
		shader_reset();
		
		_lw = _cw;
		_cw = _nw;
		_nw = i+1<_n?weights[|_j][|i+1]:1;
		
		var _x = lerp(0, w*(i+(_lw-_cw)/_n)/_n, 1);//
		var _y = h*(umod(scroll-_j+1,rows)-1);
		var _w = lerp(w, w*(1+_cw)/_n, 1);
		draw_surface_part(surf, _x, _y, _w, h, _x, _y);
		
		draw_set_font(_cw>1.5? fnt_title2 : fnt_title)
		
		draw_set_valign(fa_center);
		
		var _s = 1.5-abs(_cw-1.5);
		_x = w*(i+(_lw-1)/_n)/_n+8;
		_y += h*0.05+_cw*16;
		
		//Shadow
		draw_set_color(text_shadow);
		draw_text_transformed(_x+1, _y+1, titles[|_j][|i], _s, _s, 0);
		draw_text_transformed(_x-1, _y+1, titles[|_j][|i], _s, _s, 0);
		draw_text_transformed(_x-1, _y-1, titles[|_j][|i], _s, _s, 0);
		draw_text_transformed(_x+1, _y-1, titles[|_j][|i], _s, _s, 0);
		//Colored text
		draw_set_color(text_color);
		draw_text_transformed(_x, _y,titles[|_j][|i], _s, _s, 0);
		
	}
	
	draw_set_font(fnt_title2)
	
	var _s = 1;
	var _x = 8;
	var _y = h*(umod(scroll-_j+1,rows)-1)+16;
	
	//Shadow
	draw_set_color(text_shadow);
	draw_text_transformed(_x+1, _y+1, category[|_j], _s, _s, 0);
	draw_text_transformed(_x-1, _y+1, category[|_j], _s, _s, 0);
	draw_text_transformed(_x-1, _y-1, category[|_j], _s, _s, 0);
	draw_text_transformed(_x+1, _y-1, category[|_j], _s, _s, 0);
	//Colored text
	draw_set_color(text_color);
	draw_text_transformed(_x, _y, category[|_j], _s, _s, 0);
}
