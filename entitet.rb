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