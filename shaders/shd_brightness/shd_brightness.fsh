/*
	"Brightness and Contrast" by Xor
	
	This is a simple way of computing contrast and brightness.
*/

varying vec2 v_texcoord;
varying vec4 v_color;

//Contrast intensity (1.0 = default, higher = more contrast)
uniform float u_contrast;
//Brightness amount (1.0 = default, higher = brighter)
uniform float u_brightness;

void main()
{
	//Start with base colour
	vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
	
	//Compute final color using extrapolation
	color.rgb = mix(vec3(0.5), color.rgb + u_brightness - 1.0, u_contrast);
	
	//Output result with vertex color factored
	gl_FragColor = v_color * color;
}