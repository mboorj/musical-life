class Cell
    def initialize(row,column,char)
        @row = row
        @col = column
        @state = false #false or on state character
        @char = char #stores on character while cell is off
        @nextstate = nil
        @neighbors = []
    end

    def to_s
        unless @state == false
            return "#{@state}"
        else
            return "."
        end
    end

    def getState
        return @state
    end

    def setNext(s)
        @nextstate = s
    end

    def setState(s)
        @state = s
    end

    def addNeighbor(c)
        @neighbors << c
    end

    def liveNeighbors
        """Totals live neighbors, between 0 and 8"""
        nbrStates = {}
        living = 0
        n = 0
        until n == @neighbors.size
            checked = @neighbors[n]
            unless checked.getState == false
                living += 1
            end
            n +=1
        end
        return living
    end

    def findNext
        """Checks liveNeighbors against game rules to determine next state"""
        if @state != false && self.liveNeighbors == 2
            @nextstate = @state
        elsif @state != false && self.liveNeighbors == 3
            @nextstate = @state
        elsif @state == false && self.liveNeighbors == 3
            @nextstate = @char #set next state to on
        else
            @nextstate = false
        end
    end

    def update
        """Iterate board, clear next state"""
        @state, @nextstate = @nextstate, nil
    end

end

class Board
    def initialize(size, character)
        @size = size
        @arrays = []
        @allcells = []
        @character = character #general 'on' character for whole board
        until @arrays.size == @size
            @arrays << [] #adds an empty array for each row of the board
        end
        n = 0
        until n == @size
            m = 0
            until m == @size
                c = Cell.new(n,m,character) #creates @size cells to each row
                @arrays[n] << c
                @allcells << c
                m += 1
            end
        n += 1
        end
    end

    def to_s
        string = ""
        n = 0
        until n == @size
            m = 0
            until m == @size
                string += @arrays[n][m].to_s + " "
                m += 1
            end
            string += "\n"
            n +=1
        end
        return string
    end

    def getCellState(row,column)
        """Prevents errors from trying to get a cell that doesn't exist"""
        if row < @size && column < @size
            @arrays[row][column].getState
        else
            "dne"
        end
    end

    def setCellState(row,column,s)
        """Changes a cell's state provided the cell exists"""
        if getCellState(row,column) != "dne"
            @arrays[row][column].setState(s)
        end
    end

    def setCellNeighbors
        """Finds the row and column of each cell's neighbors and appends its
        @neighbors array. If the cell is on an edge, its neighbors are set to
        create a torus board."""
        row = 0
        until row == @size
            col = 0
            until col == @size
                target = @arrays[row][col]
                east = col + 1
                west = col - 1
                north = row - 1
                south = row + 1
                if east >= @size
                    east = 0
                end
                if west < 0
                    west = @size - 1
                end
                if north < 0
                    north = @size - 1
                end
                if south >= @size
                    south = 0
                end
                target.addNeighbor(@arrays[north][west]) #nw
                target.addNeighbor(@arrays[north][col]) #n
                target.addNeighbor(@arrays[north][east]) #ne
                target.addNeighbor(@arrays[row][east]) #e
                target.addNeighbor(@arrays[south][east]) #se
                target.addNeighbor(@arrays[south][col]) #s
                target.addNeighbor(@arrays[south][west]) #sw
                target.addNeighbor(@arrays[row][west]) #w
                col += 1
            end
            row += 1
        end
    end

    def playConway
        """Finds each cell's next state and changes it"""
        @allcells.each {|c| c.findNext}
        @allcells.each {|c| c.update}
    end

    def rPentomino(row, col, s)
        """Pre-built r pentomino pattern"""
        self.setCellState(row,col+1,s)
        self.setCellState(row,col+2,s)
        self.setCellState(row+1,col,s)
        self.setCellState(row+1,col+1,s)
        self.setCellState(row+2,col+1,s)
    end

    def glider(row,col,s)
        """Pre-built glider pattern"""
        self.setCellState(row,col+2,s)
        self.setCellState(row+1,col,s)
        self.setCellState(row+1,col+2,s)
        self.setCellState(row+2,col+1,s)
        self.setCellState(row+2,col+2,s)
    end

    def noisyConway(times)
        """Iterates board desired number of times, displaying each iteration"""
        n = 0
        until n == times
            puts "Iteration no. #{n}."
            self.playConway
            puts self.to_s
            n += 1
        end
    end

    def silentConway(times)
        """Iterates board desired number of times, only displaying final
        iteration. Return statement used to output final iteration to .txt file."""
        n = 0
        until n == times
            self.playConway
            n += 1
        end
        puts self.to_s
        return self.to_s
    end

end

def interactiveSetup
    """Interactive setup for game. Asks user for size, character, pattern,
    noisy/silent, and number of iterations."""
    puts "What size board? "
    size = gets.chomp.to_i
    puts "What character? "
    char = gets.chomp
    b = Board.new(size, char)
    b.setCellNeighbors
    h = size + 2
    w = size * 2
    puts "Would you like to run a glider or r-pentomino pattern? "
    pattern = gets.downcase.chomp
    if pattern == "glider"
        b.glider(1,1, char)
        b.glider(size/2,size/2, char)
    else
        b.rPentomino(size/2-1,size/2-1, char)
    end
    puts b.to_s
    puts "How many iterations do you want? "
    num = gets.to_i
    puts "Do you want to see each iteration, or just the final result? "
    choice = gets.downcase.chomp
    if choice == "each"
        b.noisyConway(num)
    else
        b.silentConway(num)
    exit
    end
end

#
#
#sample non interactive setup
#bo = Board.new(40,"!")
#bo.setCellNeighbors
#bo.rPentomino(19,19,"!")
#bo.silentConway(160)
#
#
interactiveSetup()
