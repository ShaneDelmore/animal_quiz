require 'set'
require_relative 'classifier'
require_relative 'animal_finder'

def penguin
  # Animal.new('penguin')
  'penguin'.to_sym
end

def hummingbird
  # Animal.new('hummingbird')
  'hummingbird'.to_sym
end

def salmon
  # Animal.new('salmon')
  'salmon'.to_sym
end

def can_it_fly
  result = Classifier.new('Can it fly?')
  result.positive_solutions << hummingbird
  result.negative_solutions << salmon
  result
end

def can_it_swim
  result = Classifier.new('Can it swim?')
  result.positive_solutions << salmon
  result.negative_solutions << hummingbird
  result
end

def does_it_have_scales
  result = Classifier.new('Does it have scales?')
  result.positive_solutions << salmon
  result
end

def empty_finder
  AnimalFinder.new()
end

def empty_question(question)
  Classifier.new(question)
end

def populated_finder
  result = empty_finder
  result.classifiers << can_it_swim
  result.classifiers << can_it_fly
  result.classifiers << does_it_have_scales
  result.animals << hummingbird
  result.animals << salmon
  result.animals << penguin
  result
end

# finder = populated_finder
finder = AnimalFinder.load

#Make sure I can load and persist animals.

#Make sure I can load and persist questions.

#Make sure animals are added either to positive or negative list, not both.
#without ever having them be in both matched and unmatched lists.

#If no questions remain to classify the set I need to just take a guess.

def ask(question)
  puts question
  answer = gets.chomp
  exit if /quit/ =~ answer
  answer
end

while finder.keep_playing?
  next_question = finder.next_classifier
  answer = ask(next_question.question)
  answer = !!(answer == 'y')
  next_question.answer = answer
end

puts "My best guesses:"
finder.potential_solutions.each do |solution|
  puts solution
end

finder.save
