module Conway

  class God
    def initialize
      @grid = Grid.new
    end

    def let_there_be_life
      @grid.make_life(1,1)
      @grid.make_life(1,2)
      @grid.make_life(1,3)
    end

    def describe_the_world(printer=WorldPrinter.new)
      @grid.print printer
    end

    def pass_judgement
      @grid.let_neighbours_know_you_are_alive
      @grid.cells_must_die
      @grid.cells_must_be_born
      @grid.the_world_revolves
    end
  end



  class WorldPrinter
    def new_row
      puts ''
    end

    def live_cell
      print 'X'
    end

    def dead_cell
      print '_'
    end
  end



  class Grid
    def initialize
      @live_cells = Hash.new(DeadCell.new)
      @next_generation = Hash.new(DeadCell.new)
    end

    def make_life x, y
      @live_cells[[x,y]] = LiveCell.new(life_listener(x,y))
    end

    def let_neighbours_know_you_are_alive
      @live_cells.each do |(x,y), cell|
        let_neighbours_of_cell_know_you_are_alive(x, y, cell)
      end
    end

    def let_neighbours_of_cell_know_you_are_alive x, y, cell
      ((y-1)..(y+1)).each do |n_y|
        ((x-1)..(x+1)).each do |n_x|
          @live_cells[[n_x, n_y]].inform_neighbour cell unless [n_x, n_y] == [x, y]
        end
      end
    end

    def cells_must_die
      @live_cells.each { |_, cell| cell.decide_fate }
    end

    def cells_must_be_born
      (0..3).each do |y|
        (0..3).each do |x|
          cell = DeadCell.new(life_listener(x,y))
          let_neighbours_of_cell_know_you_are_alive(x, y, cell)
          cell.decide_fate
        end
      end
    end

    def the_world_revolves
      @live_cells = @next_generation
      @next_generation = Hash.new(DeadCell.new)
    end

    def print printer
      (0..3).each do |y|
        printer.new_row
        (0..3).each do |x|
          @live_cells[[x, y]].print(printer)
        end
      end
    end

    def report_life(x,y)
      @next_generation[[x,y]] = LiveCell.new(life_listener(x,y))
    end

    def life_listener(x,y)
      lambda { self.report_life(x,y) }
    end
  end



  class Cell
    def initialize(lifecycle_listener=nil)
      @neighbours = []
      @lifecycle_listener = lifecycle_listener
    end

    def add_neighbour cell
      @neighbours << cell
    end

    def decide_fate
      if survives?
        @lifecycle_listener.call
      end
    end
  end



  class LiveCell < Cell
    def survives?
      @neighbours.size == 2 or @neighbours.size == 3
    end

    def inform_neighbour neighbour
      neighbour.add_neighbour self
    end

    def print(printer)
      printer.live_cell
    end
  end



  class DeadCell < Cell
    def survives?
      @neighbours.size == 3
    end

    def inform_neighbour neighbour
      #noop
    end

    def print(printer)
      printer.dead_cell
    end
  end

end

god = Conway::God.new
god.let_there_be_life

4.times do
  god.describe_the_world
  god.pass_judgement
  puts ''
end
