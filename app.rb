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
def get_input
  answer = gets.chomp
  exit if answer.downcase.start_with?('q')
  answer
end

def get_input_to_bool
  get_input.downcase.start_with?('y')
end

def ask(question)
  puts question
  get_input
end

def ask_yes_no(question)
  puts question + " (Y)es / (N)o / (Q)uit"
  get_input_to_bool
end

while finder.keep_playing?
  next_question = finder.next_classifier
  next_question.answer = ask_yes_no(next_question.question)
end

if finder.potential_solutions.length == 1 
  result = ask(finder.potential_solutions.first.to_s + '?')
  finder.user_animal = finder.potential_solutions.first if result == 'y'
end

if finder.user_animal.nil?
  if finder.potential_solutions.length > 1
    puts "I think it might be one of these but can't be sure:"
    finder.potential_solutions.each do |solution|
      puts solution.to_s
    end
  end
  finder.user_animal = ask("What was the animal you were thinking of?").to_sym
  new_question = ask("Please enter a question to help me find your animal next game.")
  classifier = empty_question(new_question)
  classifier.add_solution(finder.user_animal, true)
  finder.classifiers << classifier
end



#Add "think of an animal...
#What about when I need more classifiers for existing animals?
#Should I ask a user to tell me something about an animal I guessed incorrectly
#  because it wasn't filtered out by the current questions?
#Should I give users a way to skip a question?
#I need to rank questions based on the number of remaining animals they will classify.
#Handle adding the same question twice.
#

finder.save_and_reset
