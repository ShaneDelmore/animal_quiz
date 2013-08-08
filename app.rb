require_relative 'classifier'
require_relative 'animal_finder'
# require_relative 'cui'
# require_relative 'gui'
require_relative 'ui'
require_relative 'ui_text_adapter.rb'
require_relative 'ui_X11_adapter.rb'

# require 'fox16'
# include Fox


# adapter = UITextAdapter.new
adapter = UIX11Adapter.new
ui = UI.new(adapter)

# $app = FXApp.new
# $app.create
# ui = Gui.new($app)
# ui.ask("Can you see this?")
classifier = Classifier.load
finder = AnimalFinder.new(classifier, ui)
finder.play
finder.save_and_reset
