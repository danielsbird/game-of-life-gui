require_relative 'cell.rb'
require_relative 'grid.rb'

class Game

	attr_reader :grid

	def initialize()

		@grid = Grid.new(15, 15)
		populateGrid()
	end

	# Puts a cell in each grid space
	def populateGrid
	
		@grid.matrix.each_with_index do | row, i |

			row.each_with_index do | col, j |

				@grid.matrix[i][j] = Cell.new(i, j, false)
			end
		end
	end

	# Define which cells in Grid begin the game alive
	# Param pattern is an array of arrays
	def loadPattern(pattern)

		pattern.each do | coordinate |

			# Wrap out-of-bounds coordinates
			x = @grid.toroidalRow(coordinate[0])
			y = @grid.toroidalColumn(coordinate[1])

			@grid.matrix[x][y].state = true
		end
	end

	private

	# Return the cell at the specified row and column coordinates
	def getCell(row, column)

		return @grid.getElement(row, column)
	end

	def turn()
		# Fill in...
	end

	# Set cell state based on number of alive neighbours
	def deadOrAlive(cell)

		livingNeighbours = 0
		
		# Count number of living neighbours
		neighbours(cell).each do | neighbour |

			x = neighbour[0]
			y = neighbour[1]

			if @grid.matrix[x][y].state

				livingNeighbours += 1
			end
		end

		# Dead cells come alive when exactly three adjacent neighbours are alive
		# Alive cells die without two or three living adjacent neighbours
		if cell.state == false && livingNeighbours == 3
			cell.state = true
		elsif cell.state == true && livingNeighbours.between?(2, 3)
			cell.state = true
		else
			cell.state = false
		end
	end

	# Return x and y coordinates of all neighbouring cells as an array
	def neighbours(cell)
		
		row = cell.row
		column = cell.column
		neighbours = []

		# Subsample eight cells adjacent to given cell
		for i in ((row - 1)..(row + 1))
			for j in ((column - 1)..(column + 1))
				# Do not include given cell in sample
				if !(i == row && j == column)
					neighbours << @grid.toroidalCoordinates(i, j)
				end
			end
		end

		return neighbours
	end
end