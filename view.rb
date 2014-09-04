require_relative 'game'
require 'gosu'

class View < Gosu::Window

	def initialize

		@game = Game.new(25, 25)
		@game.loadPattern([[0, 2], [1, 0], [1, 2], [2, 1], [2, 2]])
		@margin = 1
		@height = @game.grid.rows * (10 + 1)
		@width = @game.grid.columns * (10 + 1)
		@cellHeight = 10
		@cellWidth = 10
		super @height, @width, false, 200
	end

	def update
		@game.turn
	end

	def draw

		@game.grid.iterate do | cell |

			color = cell.state == true ? Gosu::Color.argb(0xffffffff) : Gosu::Color.argb(0xff808080)
		
			# Define coordinates of cell's four corners on grid
			x1  = cell.column 	* (@cellWidth 	+ 	@margin)
			y1 	= cell.row		* (@cellHeight 	+ 	@margin)
			
			x2	= x1 + @cellWidth
			y2	= y1

			x3	= x1
			y3	= y1 + @cellHeight

			x4	= x2
			y4	= y3

			draw_quad(x1, y1, color, x2, y2, color, x3, y3, color, x4, y4, color)
		end
	end

end

view = View.new
view.show