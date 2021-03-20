#version 300 es
precision highp float;
precision highp int;
precision highp sampler2D;
out vec4 FragColor;

uniform sampler2D tex;

in vec2 texCoord;

void main()
{
    FragColor = texture(tex,texCoord);
}
