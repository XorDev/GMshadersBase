varying vec2 v_texcoord;
varying vec4 v_color;

void main()
{
	vec4 tex = v_color * texture2D( gm_BaseTexture, v_texcoord);
	vec4 invert = vec4(1.0 - tex.rgb, 1.0);
	
    gl_FragColor = invert;
}