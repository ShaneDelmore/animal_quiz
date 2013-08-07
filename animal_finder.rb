require 'yaml'
require_relative 'animal'
require_relative 'classifier'
require 'set'
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
  
  attr_accessor :classifiers, :animals, :user_animal, :ui, :skipped_classifiers

  def initialize
    @classifiers = []
    @skipped_classifiers = []
    @animals = Set.new
    @user_animal = nil
  end

  def save_and_reset
    save_animal
    update_classifiers
    reset_finder_state
    self.skipped_classifiers = []
    File.open(Dir.pwd + '/animal_finder.yaml', 'w+') {|f| f.write(self.to_yaml) }
  end

  def save_animal
    animals << user_animal if user_animal
  end

  def find_classifier(classifier)
    classifiers.find { |i| i.question == classifier.question } 
  end

  def add_or_find_classifier(classifier)
    classifiers << classifier unless find_classifier(classifier)
    find_classifier(classifier)
  end

  def add_or_update_classifier(classifier)
    add_or_find_classifier(classifier).answer = true
  end

  def update_classifiers
    if solved?
      answered_classifiers.each do |classifier|
        classifier.add_solution(user_animal, classifier.answer)
      end
    end
  end

  def reset_finder_state
    @user_animal = nil
    answered_classifiers.each do |classifier|
      classifier.answer = nil
    end
  end

  def excluded_items
    answered_classifiers.reduce(Set.new) do |acc, item| 
      acc.merge(item.excluded_items)
    end
  end

  def potential_solutions
    animals - excluded_items
  end

  def answered_classifiers
    classifiers.select { |classifier| classifier.answered? }
  end

  def unanswered_classifiers
    classifiers.select { |classifier| !classifier.answered? }
  end

  def available_classifiers
    unanswered_classifiers.select { |classifier| !skipped_classifiers.include?(classifier)}
  end

  def potential_classifiers
    available_classifiers.select do |classifier|
      (classifier.related_items & potential_solutions).length > 0
    end
  end

  def sorted_potential_classifiers
    potential_classifiers.sort_by do |classifier|
      #sort by minimum exclusions, then maximum exclusions.
      [min_exclusions(classifier), max_exclusions(classifier)]
    end
  end

  def min_exclusions(classifier)
    [(classifier.negative_solutions & potential_solutions).length, 
     (classifier.positive_solutions & potential_solutions).length].min
  end

  def max_exclusions(classifier)
    [(classifier.negative_solutions & potential_solutions).length, 
     (classifier.positive_solutions & potential_solutions).length].max
  end

  def next_classifier
    sorted_potential_classifiers.last
  end

  def keep_playing?
    next_classifier && (potential_solutions.length > 1)
  end

  def empty_question(question)
    Classifier.new(question)
  end

  def next_learning_question
    #Return the question with the fewest related items so I can learn more about it.
    available_classifiers.sort_by { |item| (item.related_items & potential_solutions).length }.first
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

  def get_answer(classifier)
    return if classifier.nil?
    classifier.answer = ask_yes_no(classifier.question)
    skipped_classifiers << classifier if classifier.answer.nil?
  end

  def ask_clarifying_questions
    get_answer(next_classifier)
    ask_clarifying_questions if keep_playing?
  end

  def get_new_question
      new_question = ask("Please enter a question to help me find your animal next game.")
      classifier = empty_question(new_question)
      classifier.add_solution(user_animal, true)
      add_or_update_classifier(classifier)
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

