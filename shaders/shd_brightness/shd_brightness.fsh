/*
	"Brightness and Contrast" by Xor
	
*/

varying vec2 v_texcoord;
varying vec4 v_color;

uniform float u_black_point;
uniform float u_white_point;


void main()
{
	//Sample base texture
	vec4 color = texture2D(gm_BaseTexture, v_texcoord);
	
	color.rgb = mix(vec3(u_black_point), vec3(u_white_point), color.rgb);
	
	//Output result with vertex colour factored
	gl_FragColor = v_color * color;
}
