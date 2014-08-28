# seed_spec.rb

require_relative 'spec_helper.rb'

class DummyClass
	include Seed
end

describe DummyClass do

	before :each do
		@dummy = DummyClass.new
	end

	subject { @dummy }

	it { should be_const_defined(:FIRST) }
	
end