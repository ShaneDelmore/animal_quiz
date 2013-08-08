require 'forwardable'
require 'yaml'
require 'set'
# require_relative 'classifier'
# require_relative 'cui'

class AnimalFinder
  extend Forwardable

  #use delegator to delegate/alias calls to ui and classifier
  def_delegator :@classifier, :classified_items, :animals

  def_delegators :@classifier, :potential_solutions, 
    :sorted_potential_constraints,
    :constraints,
    :skipped_constraints,
    :update_constraints,
    :reset_classifier_state,
    :next_constraint,
    :solved?,
    :next_learning_question,
    :add_positive_constraint

  def_delegators :@ui, :tell,
    :ask,
    :ask_yes_no

  attr_accessor :classifier, :ui 

  def initialize(classifier, ui)
    @classifier = classifier
    @ui = ui
  end

  def save_and_reset
    update_constraints
    reset_classifier_state
    classifier.save
    # File.open(Dir.pwd + '/animal_finder.yaml', 'w+') {|f| f.write(self.to_yaml) }
  end

  def keep_playing?
    next_constraint && (potential_solutions.length > 1)
  end

  def empty_question(question)
    Constraint.new(question)
  end

  def get_answer(constraint)
    return if constraint.nil?
    constraint.answer = ask_yes_no(constraint.question)
    classifier.skipped_constraints << constraint if constraint.answer.nil?
  end

  def ask_clarifying_questions
    get_answer(next_constraint)
    ask_clarifying_questions if keep_playing?
  end

  def get_new_question
      new_question = ask("Please enter a question to help me find your animal next game.")
      add_positive_constraint(new_question)
  end

  def multiple_possibilities?
    potential_solutions.length > 1
  end

  def show_potential_solutions
    tell "I thought it might be one of these but could not decide:"
    potential_solutions.each { |solution| tell solution.to_s }
  end

  def try_best_solution
    result = ask_yes_no(potential_solutions.first.to_s + '?')
    classifier.correct_solution = potential_solutions.first if result
  end

  def ask_for_help
    show_potential_solutions if multiple_possibilities?
    classifier.correct_solution = ask("What was the animal you were thinking of?").to_sym
    get_new_question
  end

  def play
    tell "Think of an animal and I will try to figure out what it is."
    ask_clarifying_questions

    #Ask one more unrelated question to help with learning.
    get_answer(next_learning_question) 

    try_best_solution unless potential_solutions.empty?
    ask_for_help unless solved?
  end
end

