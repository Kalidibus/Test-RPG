shader_type canvas_item;
render_mode blend_mix;

uniform float Frequency = 1;
uniform float MaxOpacity : hint_range(0, 1) = 1;
uniform float MinimumOpacity : hint_range(0, 1) = 0;



void fragment() {
	vec4 n_out8p0;
// Texture2D:8
	n_out8p0 = texture(TEXTURE, UV);


// VectorDecompose:9
	float n_out9p0 = n_out8p0.x;
	float n_out9p1 = n_out8p0.y;
	float n_out9p2 = n_out8p0.z;
	float n_out9p3 = n_out8p0.w;


// FloatParameter:4
	float n_out4p0 = Frequency;


// Input:2
	float n_out2p0 = TIME;


// FloatOp:5
	float n_out5p0 = n_out4p0 * n_out2p0;


// FloatFunc:3
	float n_out3p0 = sin(n_out5p0);


// FloatParameter:12
	float n_out12p0 = MaxOpacity;


// FloatFunc:13
	float n_out13p0 = 1.0 - n_out3p0;


// FloatParameter:11
	float n_out11p0 = MinimumOpacity;


// FloatOp:14
	float n_out14p0 = n_out13p0 * n_out11p0;


// MultiplyAdd:15
	float n_out15p0 = fma(n_out3p0, n_out12p0, n_out14p0);


// FloatOp:7
	float n_out7p0 = n_out9p3 * n_out15p0;


// Output:0
	COLOR.a = n_out7p0;


}
