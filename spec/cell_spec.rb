# cell_spec.rb

require_relative 'spec_helper.rb'

describe Cell do

	before :each do
		@cell = Cell.new(1, 2, false)
	end

	subject { @cell }

	describe "#new" do

		it { should be_a Cell }
	end

	describe "#row" do

		its(:row) { should eq(1) }

		it "should raise" do

			expect{@cell.row = 0}.to raise_error(NoMethodError)
		end
	end

	describe "#column" do

		its(:column) { should eq(2) }

		it "should raise" do

			expect{@cell.column = 0}.to raise_error(NoMethodError)
		end
	end

	describe "#state" do

		context "when cell is dead" do

			its(:state) { should eq(false) }
		end

		context "when cell is alive" do

			let(:state) { true }

			its(:state) { should eq(false) }
		end
	end
end