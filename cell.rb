class Cell

	attr_accessor :state
	attr_reader :row, :column

	def initialize(row, column, state)

		@row = row
		@column = column
		@state = state
	end
end