require 'gosu'

class Ball
    def initialize
        @image = Gosu::Image.new("media/ball.png")
        @image_width = 15
        @image_height = 15
        @vel_x = 5
        @vel_y = 5
        @x = 300
        @y = 33
    end

    def update
        @y += @vel_y
        @x += @vel_x
    end

    def draw
        @image.draw(@x, @y,0)
    end
end

class Player
    def initialize
        @x = 320
        @image = Gosu::Image.new("media/paddle.png")
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
    end

    def update
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
            @player.move_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
            @player.move_right
        end
    end

    def draw
        @ball.draw
        @player.draw
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