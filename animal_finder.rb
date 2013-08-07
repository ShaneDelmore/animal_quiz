require 'yaml'
require_relative 'animal'
require_relative 'constraint'
require_relative 'classifier'
require 'set'
require_relative 'cui'
#TODO move classifier collection into a new class.
#Should I also inject animals into it?
#Yes, the collection should not contain animals with no classifiers
#and should not contain classifiers of animals that it does not know about.
#Do I even need a distinct list of animals, or should I just pull it from 
#the classifiers initially?
#Keep the save and load in the animal finder, this would allow me to make
#different finders.
#Gemify the classifier.
#What is a better name for it?
#Class names should be Classifier which has a list of Constraint objects.

class AnimalFinder
  def self.load
    File.open(Dir.pwd + '/animal_finder.yaml', 'r') { |f| YAML.load(f) }
  end
  
  attr_accessor :classifier, :animals, :user_animal, :ui, :skipped_constraints

  def constraints
    classifier.constraints
  end

  def skipped_constraints
    classifier.skipped_constraints
  end

  def initialize
    @animals = Set.new
    @user_animal = nil
  end

  def save_and_reset
    save_animal
    update_constraints
    reset_finder_state
    self.skipped_constraints = []
    File.open(Dir.pwd + '/animal_finder.yaml', 'w+') {|f| f.write(self.to_yaml) }
  end

  def save_animal
    animals << user_animal if user_animal
  end

  def find_constraint(constraint)
    constraints.find { |i| i.question == constraint.question } 
  end

  def add_or_find_constraint(constraint)
    constraints << constraint unless find_constraint(constraint)
    find_constraint(constraint)
  end

  def add_or_update_constraint(constraint)
    add_or_find_constraint(constraint).answer = true
  end

  def update_constraints
    if solved?
      answered_constraints.each do |constraint|
        constraint.add_solution(user_animal, constraint.answer)
      end
    end
  end

  def reset_finder_state
    @user_animal = nil
    answered_constraints.each do |constraint|
      constraint.answer = nil
    end
  end

  def excluded_items
    answered_constraints.reduce(Set.new) do |acc, item| 
      acc.merge(item.excluded_items)
    end
  end

  def potential_solutions
    animals - excluded_items
  end

  def answered_constraints
    classifier.answered_constraints
  end

  def unanswered_constraints
    classifier.unanswered_constraints
  end

  def available_constraints
    classifier.available_constraints
  end

  def potential_constraints
    available_constraints.select do |constraint|
      (constraint.related_items & potential_solutions).length > 0
    end
  end

  def sorted_potential_constraints
    potential_constraints.sort_by do |constraint|
      #sort by minimum exclusions, then maximum exclusions.
      [min_exclusions(constraint), max_exclusions(constraint)]
    end
  end

  def min_exclusions(constraint)
    [(constraint.negative_solutions & potential_solutions).length, 
     (constraint.positive_solutions & potential_solutions).length].min
  end

  def max_exclusions(constraint)
    [(constraint.negative_solutions & potential_solutions).length, 
     (constraint.positive_solutions & potential_solutions).length].max
  end

  def next_constraint
    sorted_potential_constraints.last
  end

  def keep_playing?
    next_constraint && (potential_solutions.length > 1)
  end

  def empty_question(question)
    Constraint.new(question)
  end

  def next_learning_question
    #Return the question with the fewest related items so I can learn more about it.
    available_constraints.sort_by { |item| (item.related_items & potential_solutions).length }.first
  end

  def tell(statement)
    ui.tell(statement)
  end

  def ask(question)
    ui.ask(question)
  end

  def ask_yes_no(question)
    ui.ask_yes_no(question)
  end

  def get_answer(constraint)
    return if constraint.nil?
    constraint.answer = ask_yes_no(constraint.question)
    skipped_constraints << constraint if constraint.answer.nil?
  end

  def ask_clarifying_questions
    get_answer(next_constraint)
    ask_clarifying_questions if keep_playing?
  end

  def get_new_question
      new_question = ask("Please enter a question to help me find your animal next game.")
      constraint = empty_question(new_question)
      constraint.add_solution(user_animal, true)
      add_or_update_constraint(constraint)
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
    self.user_animal = potential_solutions.first if result
  end

  def solved?
    !user_animal.nil?
  end

  def ask_for_help
    show_potential_solutions if multiple_possibilities?
    self.user_animal = ask("What was the animal you were thinking of?").to_sym
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

