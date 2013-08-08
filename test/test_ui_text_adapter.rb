require 'minitest'
require_relative 'test_ui.rb'
require_relative '../ui_text_adapter.rb'

describe "UITextAdapter" do
  include UIAdapterTest

  before do
    @adapter = UITextAdapter.new
  end

  #I need to make a UI module and a UI adapter module
  #to separate out the responsibility of sending and receiving messages
  #from the responsibility of interpreting them.

  # it "responds to tell" do
  #   ui = Cui.new
  #   ui.must_respond_to :tell
  # end
end
