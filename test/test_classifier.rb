require 'minitest'
require_relative '../classifier.rb'

def penguin
  # Animal.new('penguin')
  'penguin'.to_sym
end

def hummingbird
  # Animal.new('hummingbird')
  'hummingbird'.to_sym
end

def salmon
  # Animal.new('salmon')
  'salmon'.to_sym
end

def can_it_fly
  result = Constraint.new('Can it fly?')
  result.positive_solutions << hummingbird
  result.negative_solutions << salmon
  result.answer = false
  result
end

def can_it_swim
  result = Constraint.new('Can it swim?')
  result.positive_solutions << salmon
  result.negative_solutions << hummingbird
  result
end

def does_it_have_scales
  result = Constraint.new('Does it have scales?')
  result.positive_solutions << salmon
  result
end

def populated_classifier
  result = Classifier.new([])
  result.constraints << can_it_fly
  result.constraints << can_it_swim
  result
end

describe Classifier do

  it "can have constraints added to it" do
    classifier = Classifier.new([])
    initial_count = classifier.constraints.length
    classifier.constraints << can_it_fly
    classifier.constraints.length.must_equal (initial_count + 1)
  end

  it "has a set of potential solutions" do
    classifier = populated_classifier
    expected = Set.new([salmon])
    actual = classifier.potential_solutions
    actual.must_equal expected
  end

  it "can narrow potential solutions by answering questions" do
    classifier = Classifier.new([])
    classifier.constraints << can_it_swim
    classifier.next_constraint.answer = true
    classifier.potential_solutions.must_equal Set.new([salmon])
  end

  it "can identify useful classifiers" do
    classifier = Classifier.new([])
    classifier.constraints << can_it_swim
    classifier.constraints << can_it_fly
    classifier.potential_constraints.must_include can_it_swim
    classifier.potential_constraints.wont_include can_it_fly
  end

  it "can provide the next classifier" do
    classifier = populated_classifier
    next_constraint = classifier.next_constraint
    next_constraint.must_equal can_it_swim
    next_constraint.answer = true
    next_constraint = classifier.next_constraint
    next_constraint.must_be_nil
  end
end
