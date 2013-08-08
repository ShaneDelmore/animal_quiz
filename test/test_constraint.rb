require 'minitest'
require_relative '../constraint.rb'

describe Constraint do
  it "has a question" do
    Constraint.new('Can it fly?').question.must_equal 'Can it fly?'
  end

  it "can have possible solutions added" do
    constraint = Constraint.new('Can it fly?')
    constraint.add_solution(:dog, false)
    constraint.add_solution(:bird, true)
    constraint.negative_solutions.must_equal Set.new([:dog])
    constraint.positive_solutions.must_equal Set.new([:bird])
  end

  it "will only store a solution once" do
    constraint = Constraint.new('Can it fly?')
    constraint.add_solution(:dog, false)
    constraint.add_solution(:dog, true)
    constraint.negative_solutions.must_equal Set.new([])
    constraint.positive_solutions.must_equal Set.new([:dog])
  end

  it "will return excluded items if the question has been answered" do
    constraint = Constraint.new('Can it fly?')
    constraint.add_solution(:dog, false)
    constraint.add_solution(:bird, true)
    expected = Set.new([:bird])
    constraint.answer = false
    constraint.excluded_items.must_equal expected
  end
end
