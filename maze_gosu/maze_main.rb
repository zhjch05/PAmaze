require 'gosu'
include Gosu

class Maze < Window
    def initialize
        super 1280, 720, false
        self.caption = "Maze GUI"

    end
end

Maze.new.show
