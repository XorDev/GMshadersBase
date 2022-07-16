//WIP! Please don't judge me!

function demo_init()
{
	weights = ds_list_create();
	shaders = ds_list_create();
	titles  = ds_list_create();
	category  = ds_list_create();
	//floats  = ds_list_create();
	rows = 0;
}

function demo_add_row(name)
{
	ds_list_add(weights, ds_list_create());
	
	ds_list_add(shaders, ds_list_create());
	
	ds_list_add(titles, ds_list_create());
	
	ds_list_add(category, name);
	
	return rows++;
}
function demo_add_shader(row, shader, title)
{
	var _num = ds_list_size(shaders[|row]);
	
	ds_list_add(weights[|row], 1);
	
	ds_list_add(shaders[|row], shader);
	
	ds_list_add(titles[|row], title);
	
	return [row, _num];
}
/*
function demo_add_uniform_float(shader, name, value, min, max)
{
	var _shader = shaders[|shader[0]][|shader[1]];
	var _uniform = shader_get_uniform(_shader, name);
	
	ds_list_add(floats[|shader[0]][|shader[1]], _uniform); 
}
*/
