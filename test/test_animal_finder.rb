require 'minitest'
require_relative '../classifier.rb'
require_relative '../animal_finder.rb'
#TODO need to make mock ui, test it, then fix up these tests.
#move classifier tests into classifier and add game tests here.
# require_relative '../cui.rb'


def mock_ui
  MiniTest::Mock.new
end

def mock_classifier
  MiniTest::Mock.new
end

def empty_finder
  ui = mock_ui
  classifier = Classifier.new([])
  AnimalFinder.new(classifier, ui)
end

def empty_question(question)
  Constraint.new(question)
end

def populated_finder
  result = empty_finder
  # result.constraints << can_it_swim
  result
end

describe AnimalFinder do
  it "can be created" do
    result = empty_finder
    result.wont_be_nil
  end

  it "can ask a user to answer a question" do
    finder = populated_finder
    constraint = Constraint.new("Is y true?")
    finder.ui.expect :ask_yes_no, true, [constraint.question]
    finder.get_answer(constraint)
    finder.ui.verify
    constraint.answer.must_equal true
  end

  
end
