require 'yaml'
require_relative 'animal'
require_relative 'classifier'
require 'set'

class AnimalFinder
  def self.load
    File.open(Dir.pwd + '/animal_finder.yaml', 'r') { |f| YAML.load(f) }
  end
  
  attr_accessor :classifiers, :animals, :user_animal

  def initialize
    @classifiers = []
    @animals = Set.new
    @user_animal = nil
  end

  def save_and_reset
    save_animal
    update_classifiers
    reset_finder_state
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

  def potential_classifiers
    unanswered_classifiers.select do |classifier|
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
    # Choose one of the two most useful questions randomly to introduce a small
    # amount of variety.
    sorted_potential_classifiers.last(2).sample
  end

  def keep_playing?
    next_classifier && (potential_solutions.length > 1)
  end
end
