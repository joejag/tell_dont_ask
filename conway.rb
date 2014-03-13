module Conway

  class God
    def initialize
      @world = World.new
    end

    def let_there_be_life
      @world.make_life(1,1)
      @world.make_life(1,2)
      @world.make_life(1,3)
    end

    def tour_the_world(visitor=WorldPrinter.new)
      @world.visit visitor
    end

    def pass_judgement
      @world.command_cells_to_meet_their_neighbours
      @world.cells_must_die
      @world.cells_must_be_born
      @world.the_world_revolves
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



  class World

    START_CELL = 0
    FINISH_CELL = 3

    def initialize
      @live_cells = Hash.new(DeadCell.new)
      @next_generation = Hash.new(DeadCell.new)
    end

    def make_life(x, y)
      @live_cells[[x,y]] = LiveCell.new(life_listener(x,y))
    end

    def command_cells_to_meet_their_neighbours
      @live_cells.each do |(x,y), cell|
        inform_neighbour_of_presence(x, y, cell)
      end
    end

    def inform_neighbour_of_presence(x, y, cell)
      neighbours = [
        [x-1, y+1], [x, y+1], [x+1, y+1],
        [x-1,  y ]          , [x+1,  y ],
        [x-1, y-1], [x, y-1], [x+1, y-1],
      ]

      neighbours.each do |(n_x, n_y)|
        @live_cells[[n_x, n_y]].inform_neighbour cell
      end
    end

    def cells_must_die
      @live_cells.each { |_, cell| cell.decide_fate }
    end

    def cells_must_be_born
      (START_CELL..FINISH_CELL).each do |y|
        (START_CELL..FINISH_CELL).each do |x|
          cell = DeadCell.new(life_listener(x,y))
          inform_neighbour_of_presence(x, y, cell)
          cell.decide_fate
        end
      end
    end

    def report_life(x,y)
      @next_generation[[x,y]] = LiveCell.new(life_listener(x,y))
    end

    def life_listener(x,y)
      lambda { self.report_life(x,y) }
    end

    def the_world_revolves
      @live_cells = @next_generation
      @next_generation = Hash.new(DeadCell.new)
    end

    def visit visitor
      (START_CELL..FINISH_CELL).each do |y|
        visitor.new_row
        (START_CELL..FINISH_CELL).each do |x|
          @live_cells[[x, y]].visit(visitor)
        end
      end
    end
  end



  class Cell
    def initialize(lifecycle_listener=lambda{})
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

    def visit visitor
      visitor.live_cell
    end
  end


  class DeadCell < Cell
    def survives?
      @neighbours.size == 3
    end

    def inform_neighbour neighbour
      # noop
    end

    def visit visitor
      visitor.dead_cell
    end
  end

end

god = Conway::God.new
god.let_there_be_life

4.times do
  god.tour_the_world
  god.pass_judgement
  puts ''
end
