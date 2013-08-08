require 'minitest'
require_relative '../animal_finder.rb'
#TODO need to make mock ui, test it, then fix up these tests.
#move classifier tests into classifier and add game tests here.
require_relative '../cui.rb'

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

def empty_finder
  ui = Cui.new
  classifier = Classifier.new([])
  AnimalFinder.new(classifier, ui)
end

def empty_question(question)
  Constraint.new(question)
end

def populated_finder
  result = empty_finder
  result.classifiers << can_it_swim
  result.animals << hummingbird
  result.animals << salmon
  result
end

describe AnimalFinder do
  it "can be created" do
    result = empty_finder
    result.wont_be_nil
  end

  # it "can have classifiers added to it" do
  #   finder = populated_finder
  #   initial_count = finder.classifiers.length
  #   finder.classifiers << can_it_fly
  #   finder.classifiers.length.must_equal (initial_count + 1)
  # end

  # it "can have animals added to it" do
  #   finder = populated_finder
  #   initial_count = finder.animals.length
  #   finder.animals << penguin
  #   finder.animals.length.must_equal (initial_count + 1)
  # end

  # it "has a set of potential solutions" do
  #   finder = populated_finder
  #   expected = Set.new([hummingbird, salmon])
  #   actual = finder.potential_solutions
  #   actual.must_equal expected
  # end

  # it "can narrow potential solutions by answering questions" do
  #   finder = populated_finder
  #   finder.classifiers << can_it_fly
  #   finder.potential_solutions.must_equal Set.new([salmon])
  # end

  # it "can identify useful classifiers" do
  #   expected = does_it_have_scales
  #   finder = populated_finder
  #   finder.classifiers << does_it_have_scales
  #   finder.potential_classifiers.must_include expected
  # end

  # it "can provide the next classifier" do
  #   finder = populated_finder
  #   next_classifier = finder.next_classifier
  #   next_classifier.must_equal can_it_swim
  #   next_classifier.answer = true
  #   next_classifier = finder.next_classifier
  #   next_classifier.must_be_nil
  # end

  # it "can guess my animal" do
  #   finder = populated_finder
  #   question = finder.next_classifier
  #   p question.question
  #   question.answer = true
  #   p finder.potential_classifiers
  #   p finder.potential_solutions
  # end
  
end
