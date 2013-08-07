require 'minitest'
require_relative '../cui.rb'
require_relative 'test_ui.rb'

describe "UI" do
  include UITest

  before do
    @ui = Cui.new
  end

  #I need to make a UI module and a UI adapter module
  #to separate out the responsibility of sending and receiving messages
  #from the responsibility of interpreting them.

  # it "responds to tell" do
  #   ui = Cui.new
  #   ui.must_respond_to :tell
  # end
end
