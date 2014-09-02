# grid_spec.rb

require_relative 'spec_helper.rb'

describe Grid do

	let(:height) {15}
	let(:width) {15}
	let(:grid) {Grid.new(height, width)}
	let(:gridNoParameters) {Grid.new()}

	subject { grid }

	describe "#new" do
		it { should be_a Grid }
	end

	describe "#rows" do
		its(:rows) { should eq(height) }

		it "should raise" do
			expect{grid.rows = 0}.to raise_error(NoMethodError)
		end

		context "when parameter not supplied" do
			subject { gridNoParameters }
			its(:rows) { should eq(20) }
		end
	end

	describe "#columns" do
		its(:columns) { should eq(width) }

		it "should raise" do
			expect{grid.columns = 0}.to raise_error(NoMethodError)
		end

		context "when parameter not supplied" do
			subject { gridNoParameters }
			its(:columns) { should eq(20) }
		end
	end

	describe "#matrix" do
		it { should respond_to(:matrix) }

		it "has a height equal to number of rows" do
			expect(grid.matrix.length).to eq(height) 
		end

		it "has a width equal to number of columns" do
			column = grid.matrix[0]
			expect(column.length).to eq(width)
		end

		it "contains only nil values" do
			grid.iterate! do | element |
				expect(element).to eq(nil)
			end
		end
	end

	describe "#iterate!" do
		it "should iterate over all element in matrix" do
			count = 0
			grid.iterate! do | counting |
				count += 1
			end
			expect(count).to eq(grid.rows * grid.columns)
			puts count
		end
	end

	describe "getCell" do

		it "should return the correct element" do
			grid.matrix[0][0] = "foo"
			expect(grid.getElement(0, 0)).to eq("foo")
		end
	end

	describe "#toroidalRow" do
		context "when coordinates supplied are outside the grid" do
			it "will wrap to the other side" do
				expect(grid.toroidalRow(height + 1)).to eq(1)
			end
		end

		context "when coordinates supplied are inside the grid" do
			it "will not wrap to the other side" do
				expect(grid.toroidalRow(5)).to eq(5)
			end
		end
	end

	describe "#toroidalColumn" do
		context "when coordinates supplied are outside the grid" do
			it "will wrap to the other side" do
				expect(grid.toroidalColumn(width + 1)).to eq(1)
			end
		end

		context "when coordinates supplied are inside the grid" do
			it "will not wrap to the other side" do
				expect(grid.toroidalColumn(5)).to eq(5)
			end
		end
	end

	describe "#toroidalCoordinates" do
		context "when coordinates supplied are outside the grid" do
			it "will wrap to the other side" do
				expect(grid.toroidalCoordinates(height + 1, width + 1)).to eq([1, 1])
			end
		end

		context "when coordinates supplied are inside the grid" do
			it "will not wrap to the other side" do
				expect(grid.toroidalCoordinates(5, 5)).to eq([5, 5])
			end
		end
	end

end