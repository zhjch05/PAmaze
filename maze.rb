## 15.0 PA maze, author Jincheng Zhang
class Maze
    attr_reader :matrix

    def deep_dup(object)
        Marshal.load(Marshal.dump(object))
    end

    def initialize(n, m)
        @matrix = []
        @n = n
        @m = m
    end

    def load(string)
        count = 0
        current_row = []
        string.split('').each do |char|
            current_row << char.to_i
            count += 1
            next unless count >= @n
            @matrix << current_row
            current_row = []
            count = 0
        end
    end

    def display
        @matrix.each do |row|
            row.each do |int|
                print "%-3d" % int.to_s
            end
            puts ''
        end
    end

    def solve(begX, begY, endX, endY)
        matrix = work(begX, begY, endX, endY)
        return false unless matrix
        #for test output
        # matrix.each do |row|
        #     row.each do |int|
        #         print "%-3d" % int.to_s
        #     end
        #     puts ''
        # end
        true
    end

    def trace(begX, begY, endX, endY)
        matrix = work(begX, begY, endX, endY)
        return false unless matrix
        e_step = matrix[endY][endX]
        s_step = matrix[begY][begX]
        x = endX
        y = endY
        solution = []
        solution << [x, y]
        (e_step-1).downto(s_step).each do |step|
            if write(x-1, y, matrix, step, solution)
                x-=1
                next
            end
            if write(x+1, y, matrix, step, solution)
                x+=1
                next
            end
            if write(x, y-1, matrix, step, solution)
                y-=1
                next
            end
            if write(x, y+1, matrix, step, solution)
                y+=1
                next
            end
        end

        until solution.empty? do
            puts solution.pop.to_s
        end
    end

    def write(x, y, matrix, step, solution)
        if in_matrix?(x, y) && matrix[y][x] == step
            solution << [x, y]
            return true
        end
        false
    end

    def work(begX, begY, endX, endY)
        matrix = deep_dup(@matrix)

        qX = Queue.new
        qY = Queue.new

        return nil unless matrix[begY][begX] == 0
        matrix[begY][begX] = 2

        qX << begX
        qY << begY

        until qX.empty?
            x = qX.pop
            y = qY.pop
            return matrix if x == endX && y == endY
            step = matrix[y][x] + 1
            color!(x + 1, y, qX, qY, matrix, step)
            color!(x - 1, y, qX, qY, matrix, step)
            color!(x, y + 1, qX, qY, matrix, step)
            color!(x, y - 1, qX, qY, matrix, step)
        end
        nil
    end

    def in_matrix?(x, y)
        x >= 0 && y < @m && y >= 0 && x < @n
    end

    def accessible?(x, y, matrix)
        in_matrix?(x, y) && matrix[y][x] == 0
    end

    def color!(x, y, qX, qY, matrix, step)
        if accessible?(x, y, matrix)
            qX << x
            qY << y
            matrix[y][x] = step
        end
    end

    private :in_matrix?, :accessible?, :color!, :work, :write
end

maze = Maze.new(9, 9)
maze.load('111111111100010001111010101100010101101110101100000101111011101100000101111111111')
# maze.display
# puts maze.solve(1, 1, 7, 7)
maze.trace(1, 1, 7, 7)
