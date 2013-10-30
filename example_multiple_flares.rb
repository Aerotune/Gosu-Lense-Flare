require 'gosu'
require_relative 'lense_flare'

class Point
  attr_accessor :x, :y
  def initialize x, y
    @x, @y = x, y
    @vel_x = (rand**0.6)*3*(rand(2) <=> 0.5)
    @vel_y = (rand**0.6)*3*(rand(2) <=> 0.5)
  end
  
  def update
    @x += @vel_x
    @y += @vel_y
  end
end

class Window < Gosu::Window
  def initialize
    super 800, 600, false
    LenseFlare.load_images self
    @mouse_color = Gosu::Color.rgb(0,40, 255)
    @flares = []
    2.times { @flares << [Gosu::Color.from_hsv(rand(190..280), 1.0, 1.0), 1.0] }
    8.times { @flares << [Gosu::Color.from_hsv(rand(190..280), 1.0, 1.0), rand**2+0.05] }
    8.times { @flares << [Gosu::Color.from_hsv(rand(190..280), 1.0, 1.0), rand**0.75] }
  end
  
  def draw
    draw_grey_backdrop
    draw_flare mouse_x, mouse_y, @mouse_color, 0.8
    t = Time.now.to_f
    @flares.each_with_index do |flare, index|
      draw_flare (Math.sin(t/5.0+index*234.2)*2.0*width), (Math.cos(t+index*231.7)*height)+Math.sin(t*1.5)*height/2.0, *flare
    end
  end
  
  def draw_flare x, y, color, strength
    z = 0
    center_x = width/2.0
    center_y = height/2.0
    #strength = 0.1#mouse_x.to_f/width
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