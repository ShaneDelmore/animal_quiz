require 'minitest'
require_relative '../classifier.rb'

# describe ClassifierSolution do
#   it "considers unmatched and matched solutions for the same item equivilant" do
#     first = ClassifierSolution.new(:some_item, true)
#     second = ClassifierSolution.new(:some_item, false)
#     first.must_equal second
#   end
# end
# 
describe Classifier do
  it "has a question" do
    Classifier.new('Can it fly?').question.must_equal 'Can it fly?'
  end

  it "can have possible solutions added" do
    classifier = Classifier.new('Can it fly?')
    result = classifier.add_solution(:dog, false)
    result.must_equal Set.new([:dog])
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
