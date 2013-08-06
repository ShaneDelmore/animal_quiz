require 'set'
require_relative 'classifier'
require_relative 'animal_finder'
require_relative 'cui'


ui = Cui.new
finder = AnimalFinder.load
finder.ui = ui
finder.play
finder.save_and_reset
#Should I loop to allow playing more than one game?

#Should I give users a way to skip a question?
#Refactor
#Test

