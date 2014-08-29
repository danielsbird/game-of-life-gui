# game_spec.rb

require_relative 'spec_helper.rb'

describe Game do

	before :each do
		@game = Game.new()
	end

	let (:grid) {@game.instance_variable_get(:@grid)}
	let (:matrix) {@game.instance_variable_get(:@grid).matrix}
	let (:cell) { @game.getCell(0, 0) }

	subject { @game }

	describe "#new" do
		it { should be_a Game }
	end

	describe "#grid" do
		it "should be a Grid" do
			expect(grid).to be_a Grid
		end
	end

	describe "#populateGrid" do
		it "should place a Cell in each grid space" do
			matrix.each do | row |
				row.each do | column |
					expect(column).to be_a Cell
				end
			end
		end

		it "should supply the correct coordinates to each cell" do
			rows = grid.rows
			columns = grid.columns
			
			for row in 0...rows do
				for col in 0...columns do
					cell = matrix[row][col]
					expect(cell.row).to eq(row)
					expect(cell.column).to eq(col)
				end
			end
		end
	end

	describe "#loadPattern" do
		context "when coordinates supplied are outside the grid" do
			it "should wrap coordinates" do
				@game.loadPattern([[grid.rows + 1, grid.columns + 1]])
				expect(matrix[1][1].state).to eq(true)
			end
		end

		context "when multiple coordinates are supplied" do
			it "should set each cell to alive" do
				@game.loadPattern(testPattern)
				matrix.each_with_index do | row, i |
					row.each_with_index do | col, j |
						if testPattern.include? [i, j]
							expect(matrix[i][j].state).to eq(true)
						end
					end
				end
			end
		end
	end

	describe "#turn" do

		let (:block) {[[14, 14], [14, 0], [0, 14], [0, 0]]}

		context "when no cells are alive" do
			it "should not set any cells to alive" do
				@game.turn
				matrix.each do | row |
					row.each do | column |
						expect(column.state).to eq(false)
					end
				end
			end
		end

		context "when four cells should live" do
			it "should have four alive cells" do
				@game.loadPattern(block)
				@game.turn
				expect(matrix.count { | cell | cell.state == true}).to eq(4)
			end
		end
	end

	describe "#getCell" do
		
		it "should return a Cell" do
			expect(@game.getCell(0, 0)).to be_kind_of(Cell)
		end

		it "should have the correct row coordinate" do
			expect(@game.getCell(0, 0).row).to eq(0)
		end

		it "should have the correct column coordinate" do
			expect(@game.getCell(0, 0).column).to eq(0)
		end
	end

	describe "#deadOrAlive" do

		def set_some_neighbours_alive(cell, numAlive)
			neighbourList = @game.neighbours(cell)
			for i in 0...numAlive
				neighbourList[i].state = true
			end
		end

		context "when dead cell has three alive neighbours" do
			it "should set the dead cell to alive" do
				set_some_neighbours_alive(cell, 3)
				@game.deadOrAlive(cell)
				expect(cell.state).to eq(true)
			end
		end

		# TODO: could not go RED, GREEN, REFACTOR because this test will
		# not fail first (since cell is already dead)
		context "when dead cell has less than three alive neighbours" do
			it "should not set the dead cell to alive" do
				set_some_neighbours_alive(cell, 2)
				@game.deadOrAlive(cell)
				expect(cell.state).to eq(false)
			end
		end

		context "when alive cell has more than three alive neighbours" do
			it "should set the alive cell to dead" do
				set_some_neighbours_alive(cell, 4)
				cell.state = true
				@game.deadOrAlive(cell)
				expect(cell.state).to eq(false)
			end
		end

		context "when alive cell has less than two alive neighbours" do
			it "should set the alive cell to dead" do
				set_some_neighbours_alive(cell, 1)
				cell.state = true
				@game.deadOrAlive(cell)
				expect(cell.state).to eq(false)
			end
		end
	end

	describe "#neighbours" do
		it "should return coordinates of neighbouring cells" do
			neighbours = @game.neighbours(cell)
			neighbours.each do | neighbour |
				x = neighbour.row
				y = neighbour.column
				expectedNeighbourCoordinates = [14, 14], [14, 0], [14, 1], [0, 14], [0, 1], [1, 14], [1, 0], [1, 1]
				expect(expectedNeighbourCoordinates).to include([x, y])
			end
		end
	end
end