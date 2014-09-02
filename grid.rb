class Grid

	attr_reader :rows, :columns, :matrix

	def initialize(rows=20, columns=20)

		@rows = rows
		@columns = columns
		@matrix = makeMatrix()
	end

	def makeMatrix()

		matrix = []

		for row in 0...rows do

			row = []

			for column in 0...columns do

				row << nil
			end

			matrix << row
		end

		return matrix
	end

	def iterate!

		@matrix.each_with_index do | row, i |
			row.each_with_index do | column, j |
				@matrix[i][j] = yield(column)
			end
		end
	end

	def iterate

		@matrix.each do | row |
			row.each do | column |
				yield(column)
			end
		end
	end

	def getElement(x, y)

		return @matrix[toroidalRow(x)][toroidalColumn(y)]
	end

	def toroidalRow(x)
		return x % rows
	end

	def toroidalColumn(y)
		return y % columns
	end

	def toroidalCoordinates(x, y)

		return [toroidalRow(x), toroidalColumn(y)]
	end
end