require 'set'

class Constraint
  # A constraint is used to limit the possible items in a set by specifying 
  #  items allowed by the constraint once an answer is provided.
  attr_reader :question
  attr_accessor :answer
  attr_accessor :negative_solutions, :positive_solutions

  def initialize(question)
    @question = question
    @negative_solutions = Set.new()
    @positive_solutions = Set.new()
  end

  def add_solution(item, matched)
    if matched 
      positive_solutions << item
      negative_solutions.delete(item)
    else
      negative_solutions << item
      positive_solutions.delete(item)
    end
  end

  def excluded_items
    return negative_solutions if answered_yes?
    return positive_solutions if answered_no?
    Set.new
  end

  def related_items
    negative_solutions + positive_solutions
  end

  def answered?
    !answer.nil?
  end

  def answered_yes?
    answer
  end

  def answered_no?
    answer == false
  end

  def ==(other)
    question == other.question
  end
end


