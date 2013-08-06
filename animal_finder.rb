require 'yaml'
require_relative 'animal'
require_relative 'classifier'
require 'set'

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

  def add_or_update_classifier(classifier)
    existing_question = classifiers.find { |i| i.question == classifier.question } 
    if existing_question
      existing_question.answer = true
    else
      classifiers << classifier
    end
  end

  def update_classifiers
    if user_animal
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

  def potential_solutions
    potential_solutions = animals
    classifiers.each do |classifier|
      potential_solutions = potential_solutions - classifier.excluded_items
    end
    potential_solutions
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

  def ask(question)
    question.answer = ui.ask_yes_no(question.question)
    skipped_classifiers << question if question.answer.nil?
  end

  def play
    ui.tell "Think of an animal and I will try to figure out what it is."

    while keep_playing?
      ask(next_classifier)
    end

    #Ask one more unrelated question to help with learning.
    ask(next_learning_question) if next_learning_question

    if potential_solutions.length == 1 
      result = ui.ask(potential_solutions.first.to_s + '?')
      self.user_animal = potential_solutions.first if result == 'y'
    end

    if user_animal.nil?
      if potential_solutions.length > 1
        ui.tell "I think it might be one of these but can't be sure:"
        potential_solutions.each do |solution|
          ui.tell solution.to_s
        end
      end
      self.user_animal = ui.ask("What was the animal you were thinking of?").to_sym
      new_question = ui.ask("Please enter a question to help me find your animal next game.")
      classifier = empty_question(new_question)
      classifier.add_solution(user_animal, true)
      add_or_update_classifier(classifier)
    end
    # update_classifiers
  end
end
