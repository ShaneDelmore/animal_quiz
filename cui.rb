class Cui
  def get_input
    answer = gets.chomp
    exit if answer.downcase.start_with?('q')
    answer
  end

  def get_input_to_bool
    input = get_input
    return nil if input.downcase.start_with?('s')
    input.downcase.start_with?('y')
  end

  def ask(question)
    tell question
    get_input
  end

  def tell(text)
    puts text
  end

  def ask_yes_no(question)
    tell question + " (Y)es / (N)o / (Q)uit / (S)kip"
    get_input_to_bool
  end
end
