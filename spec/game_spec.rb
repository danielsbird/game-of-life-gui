# game_spec.rb

require_relative 'spec_helper.rb'

describe Game do

	before :each do
		@game = Game.new()
	end

	let (:grid) {@game.instance_variable_get(:@grid)}
	let (:matrix) {@game.instance_variable_get(:@grid).matrix}
	let (:cell) { @game.getCell(0, 0) }
	let (:block) {[[14, 14], [14, 0], [0, 14], [0, 0]]}

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
			grid.iterate do | element |
				expect(element).to be_a Cell
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
				@game.loadPattern([[grid.rows, grid.columns]])
				expect(@game.getCell(0, 0).state).to eq(true)
			end
		end

		context "when multiple coordinates are supplied" do
			it "should set each cell to alive" do
				@game.loadPattern(block)
				grid.iterate do | cell |
					if block.include? [cell.row, cell.column]
						expect(cell.state).to eq(true)
					end
				end
			end
		end
	end

	describe "#turn" do

		let (:blinker) { [[0, 0], [0, 1], [0, 2]] }
		let (:unstable) { [[0, 0], [0, 1]] }

		context "when no cells are alive" do
			it "should not set any cells to alive" do
				@game.turn
				grid.iterate do | cell |
					expect(cell.state).to eq(false)
				end
			end
		end

		context "when pattern is stable" do
			it "all cells in pattern should live" do
				count = 0
				@game.loadPattern(block)
				100.times { @game.turn }
				grid.iterate do | cell |
					count += 1 if cell.state
				end
				expect(count).to eq(4)
			end
		end

		context "when pattern is unstable" do
			it "all cells in pattern should die" do
				count = 0
				@game.loadPattern(unstable)
				1.times { @game.turn }
				grid.iterate do | cell |
					count += 1 if cell.state
				end
				expect(count).to eq(0)
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
			it "should return true" do
				set_some_neighbours_alive(cell, 3)
				expect(@game.deadOrAlive(cell)).to eq(true)
			end
		end

		context "when dead cell has less than three alive neighbours" do
			it "should not set the dead cell to alive" do
				set_some_neighbours_alive(cell, 2)
				expect(@game.deadOrAlive(cell)).to eq(false)
			end
		end

		context "when alive cell has more than three alive neighbours" do
			it "should set the alive cell to dead" do
				set_some_neighbours_alive(cell, 4)
				cell.state = true
				expect(@game.deadOrAlive(cell)).to eq(false)
			end
		end

		context "when alive cell has less than two alive neighbours" do
			it "should set the alive cell to dead" do
				set_some_neighbours_alive(cell, 1)
				cell.state = true
				expect(@game.deadOrAlive(cell)).to eq(false)
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