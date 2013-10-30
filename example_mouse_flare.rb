require 'gosu'
require_relative 'lense_flare'

class Window < Gosu::Window
  def initialize
    super 800, 600, false
    LenseFlare.load_images self
  end
  
  def update
    @strength = Math.sin(Time.now.to_f)/2.0+0.5
    @strength = @strength**0.5
  end
  
  def draw
    draw_grey_backdrop
    draw_flare mouse_x, mouse_y
  end
  
  def draw_flare x, y
    z = 0
    center_x = width/2.0
    center_y = height/2.0
    strength = 1.0#mouse_x.to_f/width
    color = Gosu::Color.rgb(0,0,255)
    scale = 1.0#mouse_y.to_f/height * 2.0
    angle = 0.0
    LenseFlare.draw x, y, z, center_x, center_y, strength, color, scale, angle
  end
  
  def draw_grey_backdrop
    color = 0xFF0F0F0F
    draw_quad 0,      0,      color,
              width,  0,      color,
              0,      height, color,
              width,  height, color
  end
end

Window.new.show