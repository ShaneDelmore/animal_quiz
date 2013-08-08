require_relative 'classifier'
require_relative 'animal_finder'
# require_relative 'cui'
require_relative 'gui'

require 'fox16'
include Fox

# FXApp.new do |app|
#   charSets = [ALL_POSSIBLE_CHARS, NUMBERS + ALPHABET_LOWER + ALPHABET_UPPER]
#   myapp = SimpleUI.new(app, charSets)
#   app.create
#   p app.methods
#   app.run
#   # p myapp.tell.methods
# end

# app = FXApp.new
# main = SimpleUI.new(app)
# app.create
# app.run

# # result = FXInputDialog.getString("Enter some text...",app,"NewInputDialog","Please type some text:") 
# if result
#   print "User entered: " + result
# end
# # ui = Cui.new

$app = FXApp.new
$app.create
ui = Gui.new($app)
# ui.ask("Can you see this?")
classifier = Classifier.load
finder = AnimalFinder.new(classifier, ui)
finder.play
finder.save_and_reset
