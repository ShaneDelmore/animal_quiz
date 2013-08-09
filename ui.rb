class UI
  attr_reader :adapter

  def initialize(ui_adapter)
    @adapter = ui_adapter
  end

  def quit
    exit
  end

  def tell(text)
    adapter.write(text)
  end

  def get_input(prompt)
    answer = adapter.read(prompt)
    quit if ['quit', 'q'].include?(answer.downcase)
    answer
  end

  def get_input_to_bool(prompt)
    input = get_input(prompt)
    return nil if ['skip', 's'].include?(input.downcase)
    input.downcase.start_with?('y')
  end

  def ask(question)
    get_input(question)
  end

  def ask_yes_no(question)
    get_input_to_bool(append_option_text(question))
  end

  def append_option_text(text)
    text + " (Y)es / (N)o / (Q)uit / (S)kip"
  end
end


