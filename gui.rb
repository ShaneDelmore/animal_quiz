require 'fox16'
include Fox

class Gui
  def initialize(app)
    @app = app
    # @app.create
    @question = ''
  end

  def get_input
    answer = FXInputDialog.getString("",@app,"Animal Quiz",@question) 
    exit if answer.nil? || ['quit', 'q'].include?(answer.downcase)
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
    #This is only for a proof of concept.
    #Very ugly right now, it doesn't actually send the message to the user
    #it only sets the caption of the text of the next dialog box shown to the user.
    @question = text
  end

  def ask_yes_no(question)
    tell question + " (Y)es / (N)o / (Q)uit / (S)kip"
    get_input_to_bool
  end

end


