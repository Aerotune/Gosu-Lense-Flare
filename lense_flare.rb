class LenseFlare
  PI = Math::PI
  @@base_color          = Gosu::Color.rgba 255, 255, 255, 255
  @@rainbow_flare_color = Gosu::Color.rgba 255, 255, 255, 80
  
  class << self
    def draw x, y, z, center_x, center_y, strength, color=Gosu::Color.rgba(0, 0, 255, 255), scale=1.0, angle=0.0
      scale = 0 if scale < 0
      strength = 0 if strength < 0
      
      dx = center_x - x
      dy = center_y - y
      
      flare_angle = Gosu.angle(x, y, center_x, center_y)
      edge_angle  = Gosu.angle(dx, dy, 0, 0)
      center_dist = Math.sqrt(dx**2 + dy**2)
      edge_x = -(dx / center_dist * center_y * 0.8) + center_x
      edge_y = -(dy / center_dist * center_y * 0.8) + center_y
      
      
      prev_alpha = color.alpha
      color = color.dup
      color                  .alpha = strength * 255
      @@base_color           .alpha = strength * 255
      @@rainbow_flare_color  .alpha = strength * 70
      @@rainbow_flare_color  .alpha *= scale if (0..1) === scale
      fade = (center_dist)/@@range
      fade = 1 if fade > 1
      fade = 0 if fade < 0
      fade = Math.sin(fade**0.75 * PI)**1.5
      
      @@rainbow_flare_color  .alpha *= fade
      
      draw_horizontal_flare x, y, z, angle, scale, strength*0.75, color
      scale = scale**0.3
      draw_star_flare       x, y, z, angle, scale,            color      

      draw_hexagon        center_x + dx*0.75,   center_y + dy*0.75,   z,  angle,        scale,      color
      draw_hexagon        center_x + dx*1.5,    center_y + dy*1.5,    z,  angle,        scale*1.5,  color
      draw_blurred_circle center_x + dx*0.6,    center_y + dy*0.6,    z,  angle,        scale,      color
      draw_rainbow_flare  center_x + dx*1.2,    center_y + dy*1.2,    z,  flare_angle,  scale*1.2
      draw_rainbow_edge   edge_x, edge_y, z, edge_angle, 1.4
      
      color.alpha = prev_alpha
      #@@rainbow_flare_color.alpha = 80
      #@@base_color.alpha = 255
    end
    
    def draw_horizontal_flare x, y, z, angle, scale, strength, color
      @@horizontal_flare.draw_rot x, y, z, angle, 0.5, 0.5, scale*(strength+1)/2.0, scale,          color,        :additive
      @@horizontal_flare.draw_rot x, y, z, angle, 0.5, 0.5, scale*strength**1.5,    scale*strength, @@base_color, :additive
    end

    def draw_star_flare x, y, z, angle, scale, color
      @@star_flare.draw_rot x, y, z, angle, 0.5, 0.5, scale, scale, color, :additive
    end

    def draw_hexagon x, y, z, angle, scale, color
      @@blurred_hexagon.draw_rot x, y, z, angle, 0.5, 0.5, scale, scale, color, :additive
    end

    def draw_blurred_circle x, y, z, angle, scale, color
      @@blurred_circle.draw_rot x, y, z, angle, 0.5, 0.5, scale, scale, color, :additive
    end

    def draw_rainbow_flare x, y, z, angle, scale
      @@rainbow_flare_circle.draw_rot x, y, z, angle, 0.5, 0.5, scale, scale, @@rainbow_flare_color, :additive
    end

    def draw_rainbow_edge x, y, z, angle, scale
      @@rainbow_flare_edge.draw_rot x, y, z, angle, 0.5, 0.6, scale, scale, @@rainbow_flare_color, :additive
    end
    
    def load_images window, load_path=lense_flare_images_in_same_path_as_this_file
      @@range = window.width * 1.5
      @@star_flare           = Gosu::Image.new window, File.join(load_path, 'star_flare.png')
      @@horizontal_flare     = Gosu::Image.new window, File.join(load_path, 'horizontal_flare.png')
      @@blurred_circle       = Gosu::Image.new window, File.join(load_path, 'blurred_circle.png')
      @@blurred_hexagon      = Gosu::Image.new window, File.join(load_path, 'blurred_hexagon.png')
      @@rainbow_flare_circle = Gosu::Image.new window, File.join(load_path, 'rainbow_flare_circle.png')
      @@rainbow_flare_edge   = Gosu::Image.new window, File.join(load_path, 'rainbow_flare_edge.png')
    end
    
    def lense_flare_images_in_same_path_as_this_file
      File.join(File.dirname(__FILE__), 'lense_flare_images')
    end
  end
end