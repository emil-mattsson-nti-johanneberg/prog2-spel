require_relative "entitet"

class Trait < Entitet
    def initialize x, y, window
        @image = Gosu::Image.new(window, "media/red_col.png", true)
        super x, y, @image
        @vel = 0
    end
    def draw
        @image.draw(@x, @y, 0)
    end
    def update
        @y += @vel
    end
    def go_down 
        @y += 3
    end
    def stop
        @x = 240
        @y = 680
    end
end