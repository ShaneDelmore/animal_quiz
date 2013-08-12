require 'set'
require 'yaml'
require_relative 'constraint'

class Classifier
  # A classifier is intended to help find a specific object in a set by 
  #  applying constraints in succession to reduce the possible objects in the set.
  attr_accessor :constraints, :skipped_constraints, :correct_solution

  def self.save_file_name
    Dir.pwd + '/animal_classifier.yaml'
  end

  def self.load
    File.open(save_file_name, 'r') { |f| YAML.load(f) }
  end

  def initialize(constraints)
    @constraints = constraints
    @skipped_constraints = []
  end

  def solved?
    !correct_solution.nil?
  end

  def reset_classifier_state
    self.correct_solution = nil
    self.skipped_constraints = []
    answered_constraints.each do |constraint|
      constraint.answer = nil
    end
  end

  def save
    File.open(Classifier.save_file_name, 'w+') {|f| f.write(self.to_yaml) }
  end
  
  def save_and_reset
    update_constraints
    reset_classifier_state
    save
  end

  def skip(constraint)
    skipped_constraints << constraint
  end

  def update_constraints
    if solved?
      answered_constraints.each do |constraint|
        constraint.add_solution(correct_solution, constraint.answer)
      end
    end
  end

  def classified_items
    constraints.reduce(Set.new) do |acc, item| 
      acc.merge(item.related_items)
    end
  end

  def excluded_items
    answered_constraints.reduce(Set.new) do |acc, item| 
      acc.merge(item.excluded_items)
    end
  end

  def potential_solutions
    classified_items - excluded_items
  end

  def answered_constraints
    constraints.select { |constraint| constraint.answered? }
  end

  def unanswered_constraints
    constraints.select { |constraint| !constraint.answered? }
  end

  def available_constraints
    unanswered_constraints.select { |constraint| !skipped_constraints.include?(constraint)}
  end

  def potential_constraints
    available_constraints.select do |constraint|
      (constraint.related_items & potential_solutions).length > 0
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

  def sorted_potential_constraints
    potential_constraints.sort_by do |constraint|
      #sort by minimum exclusions, then maximum exclusions.
      [min_exclusions(constraint), max_exclusions(constraint)]
    end
  end

  def next_constraint
    sorted_potential_constraints.last
  end

  def next_learning_question
    #Return the question with the fewest related items so I can learn more about it.
    available_constraints.sort_by { |item| (item.related_items & potential_solutions).length }.first
  end

  def find_constraint(constraint)
    constraints.find { |i| i.question == constraint.question } 
  end

  def add_or_find_constraint(constraint)
    constraints << constraint unless find_constraint(constraint)
    find_constraint(constraint)
  end

  def add_positive_constraint(question)
    constraint = add_or_find_constraint(Constraint.new(question))
    constraint.add_solution(correct_solution, true)
  end

  def empty_question(question)
    Constraint.new(question)
  end
end
