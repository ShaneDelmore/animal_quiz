require 'set'

class Constraint
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

  #this feels awkward, do I need a new answered question class?
  def excluded_items
    return Set.new() if !answered?
    if answer
      negative_solutions
    else
      positive_solutions
    end
  end

  def related_items
    negative_solutions | positive_solutions
  end

  def answered?
    !answer.nil?
  end

  def ==(other)
    question == other.question
  end
end


