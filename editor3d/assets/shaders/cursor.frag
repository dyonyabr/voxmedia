vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  vec4 pixel = Texel(texture, texture_coords );

  vec4 def_color =  pixel * color;
  vec4 alt_color = vec4(1-def_color.x, 1-def_color.y, 1-def_color.z, color.w);

  return mix(alt_color, def_color, 1);
}