varying vec2 v_texcoord;
varying vec4 v_color;

uniform float u_saturation;

void main()
{
	vec4 tex = v_color * texture2D( gm_BaseTexture, v_texcoord);
	float gray = dot(tex, vec4(0.587, 0.299, 0.114, 0));
	
	vec4 shade = vec4(gray, gray, gray, tex.a);
    gl_FragColor = mix(shade, tex, u_saturation);
}