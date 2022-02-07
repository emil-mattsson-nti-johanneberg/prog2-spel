require_relative "entitet"

class Player < Entitet
    attr_accessor :lifes, :score
    def initialize x, y, window
        @image = Gosu::Image.new(window, "media/paddle.png", true)
        super x, y, @image
        @lifes = 3
        @score = 0
    end
    def draw
        @image.draw(@x, @y, 0)
        #Gosu.draw_rect(@x, @y, 100, 10, Gosu::Color::WHITE)
    end
    def move_left
        @x -= 10
    end
    def move_right
        @x += 10
    end
end