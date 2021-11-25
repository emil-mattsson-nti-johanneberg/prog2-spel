require 'gosu'

module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
end

 class Entitet
    attr_accessor :x, :y
    def initialize
        @x = x 
        @y = y 
    end

    def collides? ball
        if y == samma
            if x överlappar

            end
        end
        @aux = ball.x < @x+width && ball.x+ball.width > @x && ball.y < @y+height && ball.y+ball.height > @y
        if @aux
          ball.vy = -ball.vy
        end
         
        return @aux
    end
end

class Brick
    def initialize
        @image = Gosu::Image.new("media/brick.png")
    end

    def draw
        @image.draw(@x, @y, 0)
    end
end

class Ball

    attr_accessor :vel_y, :vel_x, :y, :x
    attr_reader :lifes
    def initialize
        @image = Gosu::Image.new("media/ball.png")
        @image_width = 15
        @image_height = 15
        @vel_x = 5
        @vel_y = 5
        @x = 300
        @y = 390
        @lifes = 3
    end

    def reset 
        @x = 300
        @y = 390
        @vel_x = 5
        @vel_y = 5
    end

    def update
        if @x + @image_width >= 640 || @x < 0
            @vel_x *= -1
        end
        if @y < 0
            @vel_y *= -1
        end

        @y += @vel_y
        @x += @vel_x
    end

    def draw
        @image.draw(@x, @y,0)
    end
end

class Player
    attr_accessor :x, :lifes
    def initialize
        @x = 320
        @image = Gosu::Image.new("media/paddle.png")
        @lifes = 3
    end
    def reset
        @x = 320
        @y = 420    
    end
    def move_left
        @x -= 5
    end

    def move_right
        @x += 5
    end

    def draw
        @image.draw_rot(@x, 420)
    end
end

class Game < Gosu::Window
    def initialize 
        super 640, 480
        self.caption = "Game"
        @player = Player.new
        @ball = Ball.new
        @font = Gosu::Font.new(20)
        @lifes = 3
    end

    def draw
        @ball.draw
        @player.draw
        @font.draw_text("LIFES: #{@lifes}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    end

    def update
        @ball.update
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
            @player.move_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
            @player.move_right
        end

        if @ball.y == 400 
            if @ball.x < @player.x+50 && @ball.x > @player.x-50
                @ball.vel_y *= -1
                @ball.vel_y *= 1.1
            end
        end

        if @ball.y > 640 and button_down? Gosu::KB_SPACE
            @lifes -= 1
            @ball.reset
            @player.reset
        end
    end
    def button_down(id)
        if id == Gosu::KB_ESCAPE
          close
        else
          super
        end
    end
end

Game.new.show