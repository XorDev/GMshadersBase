/*
	"LUT" by Xor
	
	Reads from Look Up Texture for color grading.
*/

varying vec2 v_texcoord;
varying vec4 v_color;

//LUT intensity (0.0 = original color, 1.0 = LUT color)
uniform float u_intensity;
//LUT
uniform sampler2D u_LUT;

//Number of colors per channel (64 is standard)
#define COLOR_NUM 64.0
//Number of blue-cells in each horizontally and vertically
#define CELL_NUM vec2(8.0, 8.0)
//COLOR_NUM = 32, CELL_NUM = vec2(32.0, 1.0) is also common

//Finds a color on the LUT (with optional cell offset)
vec3 lookup(vec3 ind, vec3 off)
{
	//Rounds the color to the nearest index and clamps it to the correct range
	vec3 index = clamp(ind - off, 0.0, COLOR_NUM-1.0);
	//Converts the 3D index value to 2D LUT coordinates
	vec2 coord = (index.rg / COLOR_NUM + mod(floor(index.b / vec2(1, CELL_NUM.x)), CELL_NUM)) / CELL_NUM;
	
	//Reads the color from the the LUT
	return texture2D(u_LUT, coord).rgb;	
}
//LUT look-up with per-channel interpolation
vec3 lookup_interpolated(vec3 col)
{
	//Compute index ranging from (-0.5 to COLOR_NUM - 0.5)
	vec3 ind = col * COLOR_NUM - 0.5;
	//Fractional part of index for interpolation
	vec3 fra = fract(ind);
	//Samples the neighboring RGB cells for interpolation
	vec3 col000 = lookup(ind, fra - vec3(0,0,0));
	vec3 col100 = lookup(ind, fra - vec3(1,0,0));
	vec3 col010 = lookup(ind, fra - vec3(0,1,0));
	vec3 col110 = lookup(ind, fra - vec3(1,1,0));
	vec3 col001 = lookup(ind, fra - vec3(0,0,1));
	vec3 col101 = lookup(ind, fra - vec3(1,0,1));
	vec3 col011 = lookup(ind, fra - vec3(0,1,1));
	vec3 col111 = lookup(ind, fra - vec3(1,1,1));
	
	//Blend between the color cells
	return mix(mix(mix(col000, col100, fra.r), mix(col010, col110, fra.r), fra.g),
			   mix(mix(col001, col101, fra.r), mix(col011, col111, fra.r), fra.g), fra.b);
}

void main()
{
	//Sample base texture
	vec4 color = texture2D(gm_BaseTexture, v_texcoord);
	
	//Sample interpolated LUT
	vec3 lut_color = lookup_interpolated(color.rgb);
	//Blend based on intensity
	color.rgb = mix(color.rgb, lut_color, u_intensity);
	
	//Output result with vertex colour factored
	gl_FragColor = v_color * color;
}
