require 'yaml'
require_relative 'animal'
require_relative 'classifier'
require 'set'

class AnimalFinder
  def self.load
    File.open(Dir.pwd + '/animal_finder.yaml', 'r') { |f| YAML.load(f) }
  end
  
  attr_accessor :classifiers, :animals

  def initialize
    @classifiers = []
    @animals = Set.new
  end

  def save
    # puts Dir.pwd + '/animal_finder.yaml'
    File.open(Dir.pwd + '/animal_finder.yaml', 'w+') {|f| f.write(self.to_yaml) }
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

  def next_classifier
    potential_classifiers.first
  end

  def keep_playing?
    next_classifier && (potential_solutions.length > 1)
  end
end
