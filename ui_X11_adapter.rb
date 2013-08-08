require 'fox16'
include Fox

class UIX11Adapter
  
  def initialize_app
    @app = FXApp.new
    @app.create
  end

  # def initialize
  #   initialize_app
  # end

  def app
    # @app ||= initialize_app #does this syntax work with the create syntax?
    initialize_app if @app.nil?
    @app
  end

  def write(statement)
    FXInputDialog.getString("",app,"Animal Quiz",statement) 
  end

  def read(question)
    FXInputDialog.getString("",app,"Animal Quiz",question) 
  end
end




