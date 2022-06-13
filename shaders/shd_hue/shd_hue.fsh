/*
	"Hue & Saturation" by Xor
	
	A simple hueshift and saturation shader.
*/

varying vec2 v_texcoord;
varying vec4 v_color;

//Hue shift value (0.0 = no shift, to 1.0 = full shift)
uniform float u_hue_shift;
//Saturation amount (0.0 = grayscale, 1.0 = normal and beyond boosts saturation)
uniform float u_saturation;

//Tau (pi*2) for trig math
#define TAU 6.283185

//Hue shift by transforming YIQ colour space: en.wikipedia.org/wiki/YIQ
//Inputs are colour, hue shift angle (in radians) and saturation multiplier
vec3 hue(vec3 col, float ang, float sat)
{
	//Colour conversion matrices
	const mat3 RGBtoYIQ = mat3(0.299,  0.587,  0.114,
							   0.596, -0.275, -0.321,
							   0.212, -0.523,  0.311);
	
	const mat3 YIQtoRGB = mat3(1.0,  0.956,  0.621,
							   1.0, -0.272, -0.647,
							   1.0, -1.107,  1.704);
	//Compute YIQ colour
	vec3 YIQ = col * RGBtoYIQ;
	//Rotate I and Q chrominance values and scale for saturation
	YIQ.yz *= mat2(cos(ang), -sin(ang), sin(ang), cos(ang)) * sat;
	
	//Convert back to RGB colour space
    return YIQ * YIQtoRGB;
}

void main()
{
	//Sample base texture
	vec4 color = texture2D(gm_BaseTexture, v_texcoord);
	
	//Hue shift and saturation
	color.rgb = hue(color.rgb, u_hue_shift * TAU, u_saturation);
	
	//Output result with vertex colour factored
	gl_FragColor = v_color * color;
}
