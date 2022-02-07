require 'gosu'
require_relative "player"
require_relative "ball"
require_relative "brick"
require_relative "trait"
require_relative "playerz"

module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
end

class Game < Gosu::Window
    def initialize 
        super 640, 480, false
        self.caption = "Game"
        create_blocks
        @playerz = Playerz.new(270, 400)
        @player = Player.new(270, 450, self)
        @ball = Ball.new(320, 420, self)
        @font = Gosu::Font.new(20)
        @trait = Trait.new(rand(100..540), -50, self)
        @lifes = 3
    end

    def create_blocks
        @blocks = []
        8.times { |i| @blocks.push(Brick.new(self, 82*i,80)) }
        8.times { |i| @blocks.push(Brick.new(self, 82*i,110)) }
        8.times { |i| @blocks.push(Brick.new(self, 82*i,140)) }
        8.times { |i| @blocks.push(Brick.new(self, 82*i,170)) }
    end

    def update
        @ball.update
        @ball.collect_blocks(@blocks)
        @trait.update
        
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
            @player.move_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
            @player.move_right
        end
        if @blocks.length < 16
            @trait.go_down
        end
        #if @trait.x.between?(@player.x-30, @player.x+100)
         #   if @trait.y > 450
          #      @trait.stop
           # end
        #end
        if @player.collides?(@ball)
            @ball.vel_x *= 1.05
            @ball.vel_y *= 1.05
            if @blocks.length == 0
                create_blocks
                @ball.vel_x *= 1.1
                @ball.vel_y *= 1.1
            end
        end
        if @ball.y > 640 and button_down? Gosu::KB_SPACE
            @lifes -= 1
            @ball.reset @player.x, @player.y 
        end
    end
    def draw
        @trait.draw
        @ball.draw
        @blocks.each { |block| block.draw }
        @player.draw
        @playerz.draw
        @font.draw_text("LIFE: #{@lifes}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw_text("SCORE: #{@ball.score}", 10, 30, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        if @lifes == 0
            @font.draw_text("GAME OVER YOU GOT: #{@ball.score}", 90, 240, ZOrder::UI, 2.0, 2.0, Gosu::Color::YELLOW)
            @ball.vel_x = 0
            @ball.vel_y = 0
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