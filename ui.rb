class UI
  attr_reader :adapter

  def initialize(ui_adapter)
    @adapter = ui_adapter
  end

  def tell(text)
    adapter.write(text)
  end

  def get_input(prompt)
    answer = adapter.read(prompt)
    exit if ['quit', 'q'].include?(answer.downcase)
    answer
  end

  def get_input_to_bool(prompt)
    input = get_input(prompt)
    return nil if input.downcase.start_with?('s')
    input.downcase.start_with?('y')
  end

  def ask(question)
    get_input(question)
  end

  def ask_yes_no(question)
    question += " (Y)es / (N)o / (Q)uit / (S)kip"
    get_input_to_bool(question)
  end
end


