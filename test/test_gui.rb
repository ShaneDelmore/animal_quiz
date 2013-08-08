require 'minitest'
require_relative '../gui.rb'
require_relative 'test_ui.rb'
require 'fox16'
include Fox

def get_FXApp_singleton
  if $app
    $app
  else
    $app = FXApp.new
    $app.create
  end
end

describe "UI" do
  include UITest

  before do
    @ui ||= Gui.new(get_FXApp_singleton)
  end

  #I need to make a UI module and a UI adapter module
  #to separate out the responsibility of sending and receiving messages
  #from the responsibility of interpreting them.

  # it "responds to tell" do
  #   ui = Cui.new
  #   ui.must_respond_to :tell
  # end
end

