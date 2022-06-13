/*
	"RGB/HSV Transforms" by Xor
	
	Just some functions for RGB/HSV conversions.
	No effect
*/

varying vec2 v_texcoord;
varying vec4 v_color;

//Based on: https://www.shadertoy.com/view/lsS3Wc
//Converts an RGB vector into HSV color
vec3 hsv(vec3 c)
{
	//Near-zero epsilon (to avoid division by 0.0)
	#define E 1e-7
	
	//Channel shift vector
    const vec4 S = vec4(0, -1, 2, -3) / 3.0;
	//Sort green-blue channels (highest to lowest)
    vec4 P = (c.b<c.g) ? vec4(c.gb, S.rg) : vec4(c.bg, S.wz);
	//Sort red-green-blue channels (highest to lowest)
    vec4 Q = (P.r<c.r) ? vec4(c.r, P.gbr) : vec4(P.rga, c.r);
	//Find the difference between the highest and lowest RGB for saturation
    float D = Q.x - min(Q.w, Q.y);
	//Put it all together
    return vec3(abs(Q.z + (Q.w - Q.y) / (6.0*D+E)), D / (Q.x+E), Q.x);
}

//Converts hue, saturation and value back to RGB color
vec3 rgb(float h, float s, float v)
{
	//Compute RGB hue
    vec3 RGB = clamp(abs(mod(h*6.0+vec3(0,4,2), 6.0)-3.0)-1.0, 0.0, 1.0);
	//Multiply by value and mix for saturation
    return v * mix(vec3(1), RGB, s);
}

void main()
{
	//Sample base texture
	vec4 color = texture2D(gm_BaseTexture, v_texcoord);
	
	//Output result with vertex colour factored
	gl_FragColor = v_color * color;
}
