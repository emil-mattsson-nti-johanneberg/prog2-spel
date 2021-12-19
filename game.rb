require 'gosu'

class Entitet
    attr_accessor :x, :y
    def initialize x, y, sprite
      @x = x
      @y = y
      @sprite = sprite
    end
  
    def width
      @sprite.width
    end
  
    def height
      @sprite.height
    end
  
    def draw
      @sprite.draw x, y, 0
    end

    def collides? (ball)
        @aux = ball.x < @x+width && ball.x+ball.width > @x && ball.y < @y+height && ball.y+ball.height > @y
        if @aux
          ball.vel_y = -ball.vel_y
        end
           
        return @aux
    end

end

module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
end

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

class Ball < Entitet
    attr_accessor :vel_y, :vel_x
    attr_reader :lifes, :score
    def initialize x, y, window
        @window = window
        @image = Gosu::Image.new(window, "media/ball.png", true)
        super x, y-25, @image
        @vel_x = @vel_y = -2
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

class Player < Entitet
    attr_accessor :x, :lifes
    def initialize x, y, window
        @image = Gosu::Image.new(window, "media/paddle.png", true)
        super x, y, @image
        @lifes = 3
        @score = 0
    end
    def draw
        @image.draw_rot(@x, 420)
    end
    def move_left
        @x -= 5
    end
    def move_right
        @x += 5
    end
end

class Game < Gosu::Window
    def initialize 
        super 640, 480, false
        self.caption = "Game"
        create_blocks
        @player = Player.new(330, 450, self)
        @ball = Ball.new(320, 420, self)
        @font = Gosu::Font.new(20)
        @lifes = 3
    end

    def create_blocks
        @blocks = []
        8.times { |i| @blocks.push(Brick.new(self, 82*i,80)) }
        8.times { |i| @blocks.push(Brick.new(self, 82*i,110)) }
        8.times { |i| @blocks.push(Brick.new(self, 82*i,140)) }
        8.times { |i| @blocks.push(Brick.new(self, 82*i,170)) }
        8.times { |i| @blocks.push(Brick.new(self, 82*i,200)) }
    end

    def draw
        @ball.draw
        @blocks.each { |block| block.draw }
        @player.draw
        @font.draw_text("LIFES: #{@lifes}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw_text("SCORE: #{@ball.score}", 10, 30, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    end

    def update
        @ball.update
        @ball.collect_blocks(@blocks)
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

        #if @player.collides?(@ball)
     # @ball.vel_x *= 1.1
      #@ball.vel_y *= 1.1
      #if @blocks.length == 0
        #create_blocks
        #@ball.vel_x *= 1.25
        #@ball.vel_y *= 1.25
      #end
    #end

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