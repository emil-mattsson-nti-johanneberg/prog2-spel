require 'gosu'

module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
end

class Brick
    attr_reader :x, :y, :typ
    def initialize(x, y, typ)
        @x = x 
        @y = y
        @typ = typ
    end

    def x1
        40 * x + 1
    end
    def x2
        40 * (x+1) - 1
    end
    def y1
        20 * y + 1
    end
    def y2
        20 * (y+1) - 1
    end
    
    def contains?(ball)
        @ball.x >= x1 && @ball.x <= x2 && @ball.y >= y1 && @ball.y <= y2
    end
    
    def hit!
        @destroyed = true
    end
    def color
        case typ
        when :aqua
          Gosu::Color::AQUA
        when :red
          Gosu::Color::RED
        when :green
          Gosu::Color::GREEN
        when :blue
          Gosu::Color::BLUE
        when :yellow
          Gosu::Color::YELLOW
        when :fuchsia
          Gosu::Color::FUCHSIA
        when :cyan
          Gosu::Color::CYAN
        when :gray
          Gosu::Color::GRAY
        else raise
        end
    end

    def draw(window)
        window.draw_quad(x1, y1, color, x2, y1, color, x2, y2, color, x1, y2, color)
    end
end

class Ball
    attr_accessor :vel_y, :vel_x, :y, :x, :blocks
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
        @blocks = blocks
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

        old_x = @x
        old_y = @y

        @blocks.each do |block|
            if block.contains?(self)
                block.hit!
                if old_y < block.y1
                    @y -= (@y - block.y1)
                    @vel_y *= -1
                elsif old_y > block.y2
                    @y += (block.y2 - @y)
                    @vel_y *= -1
                elsif old_x < block.x1
                    @x -= (@x - block.x1)
                    @vel_x *= -1
                elsif old_x > block.x2
                    @x += (block.x2 - @x)
                    @vel_x *= -1
                else
                    raise
                end
            end       
        end
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
        @bricks = [:gray, :red, :green, :blue, :yellow, :fuchsia, :cyan, :gray].each_with_index.flat_map do |color, i|
            16.times.map do |j|
              Brick.new(j, i+4, color)
            end
        end
    end

    def draw
        @ball.draw
        @player.draw
        @font.draw_text("LIFES: #{@lifes}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        @bricks.each do |brick|
            brick.draw(self)
        end
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