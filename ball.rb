require_relative "entitet"

class Ball < Entitet
    attr_accessor :vel_x, :vel_y, :x, :y
    attr_reader :lifes, :score
    def initialize x, y, window
        @window = window
        @image = Gosu::Image.new(window, "media/ball.png", true)
        super x, y-25, @image
        @vel_x = @vel_y = -5
        @score = 0
    end

    def reset x, y 
        @x = x
        @y = y-25
        @vel_x = @vel_x * -0.75
        @vel_y = @vel_y * -0.75
    end

    def update
        @x += @vel_x
        @y += @vel_y

        if @x < 0 || @x > @window.width-width
            @vel_x = -@vel_x
        end

        if @y < 0 
            @vel_y = -@vel_y
        end
    end
    def collect_blocks(bricks)
        bricks.reject! do |brick| 
          if brick.collides? (self)
            @score += 100 
          end
        end
    end
end