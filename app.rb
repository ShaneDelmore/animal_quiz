require_relative 'classifier'
require_relative 'animal_finder'
require_relative 'ui'
require_relative 'ui_text_adapter.rb'
require_relative 'ui_X11_adapter.rb'


if ARGV.include? '-gui'
  adapter = UIX11Adapter.new
else
  adapter = UITextAdapter.new
end

ui = UI.new(adapter)

classifier = Classifier.load
finder = AnimalFinder.new(classifier, ui)
finder.play
finder.save_and_reset

