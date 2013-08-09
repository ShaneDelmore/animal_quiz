require 'minitest'
require 'bogus/minitest/spec'
require_relative '../classifier.rb'
require_relative '../animal_finder.rb'
require_relative '../ui.rb'

def fake_ui
  fake(:UI, tell: nil)
end

def empty_finder
  ui = fake_ui
  classifier = Classifier.new([])
  AnimalFinder.new(classifier, ui)
end

def empty_question(question)
  Constraint.new(question)
end

def populated_finder
  result = empty_finder
  result.classifier = populated_classifier
  result
end

def ready_to_play_unsuccessfully
  finder = empty_finder
  finder
end

def ready_to_play
  finder = populated_finder
  finder
end

describe AnimalFinder do
  it "can be created" do
    result = empty_finder
    result.wont_be_nil
  end

  it "can ask a user to answer a question" do
    finder = populated_finder
    constraint = Constraint.new("Is y true?")
    stub(finder.ui).ask_yes_no(any_args) { true }
    finder.get_answer(constraint)
    constraint.answer.must_equal true
  end

  it "will ask the user for the correct animal if it fails to guess it" do
    finder = ready_to_play_unsuccessfully
    stub(finder.ui).ask("What was the animal you were thinking of?") { "dog" }
    finder.play
    finder.classifier.correct_solution.must_equal :dog
  end

  it "can try to guess the animal you are thinking of" do
    finder = ready_to_play
    finder.play
    finder.classifier.correct_solution.must_equal :salmon
  end

end

#Helper methods to populate game and allow full play.
def can_it_fly
  result = Constraint.new('Can it fly?')
  result.positive_solutions << :hummingbird
  result.negative_solutions << :salmon
  result.answer = false
  result
end

def can_it_swim
  result = Constraint.new('Can it swim?')
  result.positive_solutions << :salmon
  result.negative_solutions << :hummingbird
  result
end

def does_it_have_scales
  result = Constraint.new('Does it have scales?')
  result.positive_solutions << :salmon
  result
end

def populated_classifier
  result = Classifier.new([])
  result.constraints << can_it_fly
  result.constraints << can_it_swim
  result
end
