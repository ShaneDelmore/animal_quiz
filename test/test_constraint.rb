require 'minitest'
require_relative '../classifier.rb'

describe Classifier do
  it "has a question" do
    Classifier.new('Can it fly?').question.must_equal 'Can it fly?'
  end

  it "can have possible solutions added" do
    classifier = Classifier.new('Can it fly?')
    classifier.add_solution(:dog, false)
    classifier.add_solution(:bird, true)
    classifier.negative_solutions.must_equal Set.new([:dog])
    classifier.positive_solutions.must_equal Set.new([:bird])
  end

  it "will only store a solution once" do
    classifier = Classifier.new('Can it fly?')
    classifier.add_solution(:dog, false)
    classifier.add_solution(:dog, true)
    classifier.negative_solutions.must_equal Set.new([])
    classifier.positive_solutions.must_equal Set.new([:dog])
  end

  it "will return excluded items if the question has been answered" do
    classifier = Classifier.new('Can it fly?')
    classifier.add_solution(:dog, false)
    classifier.add_solution(:bird, true)
    expected = Set.new([:bird])
    classifier.answer = false
    classifier.excluded_items.must_equal expected
  end
end
