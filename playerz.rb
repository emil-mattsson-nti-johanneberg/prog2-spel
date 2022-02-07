class Playerz
    def initialize
        @i
    end
    def draw
        Gosu.draw_rect(@x, @y, 100, 10, Gosu::Color::WHITE)
    end
    def movez_left
        @x -= 10
    end
    def movez_right
        @x += 10
    end
end
