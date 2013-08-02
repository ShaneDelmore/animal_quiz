require 'minitest'
require_relative '../animal.rb'

describe Animal do

  it "should have a name" do
    Animal.new('beagle').name.must_equal 'beagle'
  end

  it "should be equivilant to other animal objects of the same species" do
    Animal.new('dog').must_equal Animal.new('dog')
  end
end
