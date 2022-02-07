require_relative "entitet"

class Brick < Entitet
    attr_reader :x, :y
    def initialize(window,x,y)
        @image = Gosu::Image.new(window, "media/block.png", true)
        super x, y, @image
    end
    def draw
        @image.draw(@x, @y, 0)
    end
end