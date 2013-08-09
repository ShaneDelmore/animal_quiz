require 'minitest'
require 'bogus/minitest/spec'
require_relative '../ui.rb'
require_relative './test_ui_interface.rb'
require_relative '../ui_text_adapter.rb'

def mock_ui_adapter
  MiniTest::Mock.new
end

def fake_ui_adapter
  fake(:UITextAdapter, write: nil)
end

def stub_read(adapter, result)
  stub(adapter).read(any_args) { result }
end

def stub_ask(adapter, result)
  stub(adapter).ask(any_args) { result }
end

describe UI do
  include UIInterfaceTest
  
  before do
    @adapter = fake_ui_adapter
    @ui = UI.new(@adapter)
  end

  it "can identify bogus calls" do
    expected = "Yes"
    stub_read(@adapter, expected)
    #example of a mistake bogus would catch below
    # stub_ask(@adapter, expected)
    @ui.ask("Can you hear me now?").must_equal expected
    # @adapter.must_have_received :read, question
  end

  it "can tell the user something" do
    statement = "something"
    @ui.tell(statement).must_be_nil
  end

  it "can ask the user for input" do
    expected = "Yes"
    stub_read(@adapter, expected)
    @ui.ask("Can you hear me now?").must_equal expected
  end

  it "will return true if the user answers yes" do
    stub_read(@adapter, "Yes")
    @ui.ask_yes_no("Do you think yes should return true?").must_equal true
  end

  it "will return false if the user answers no" do
    stub_read(@adapter, "No")
    @ui.ask_yes_no("Is testing a waste of time?").must_equal false
  end

  it "will return nil if the user answers skip" do
    stub_read(@adapter, "skip")
    @ui.ask_yes_no("Are you stumped by this question?").must_be_nil
  end

  it "will quit if the user enters quit" do
    ui = UI.new(@adapter)
    #Stub this because I don't really want to call exit in the middle of running my test.
    stub(ui).quit
    stub_read(@adapter, "quit")
    ui.ask("Would you like to quit?")
    ui.must_have_received :quit, []
  end
end
