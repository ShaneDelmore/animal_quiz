require 'set'
require_relative 'constraint'

class Classifier
  attr_accessor :constraints, :skipped_constraints

  def initialize(constraints)
    @constraints = constraints
    @skipped_constraints = []
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
end
