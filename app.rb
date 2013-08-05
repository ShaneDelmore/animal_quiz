require 'set'
require_relative 'classifier'
require_relative 'animal_finder'
require_relative 'cui'


ui = Cui.new

finder = AnimalFinder.load
# Create new ui object
# set finder.ui = ui
finder.ui = ui
finder.play
# finder.save_and_reset
#Should I loop to allow playing more than one game?

#Should I give users a way to skip a question?
#Should I ask for input on questions that do not classify an existing animal?
#Before I give up ask the question that classifies the fewest animals to improve the system.
#Refactor
#Test

finder.save_and_reset
