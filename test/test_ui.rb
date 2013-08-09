require 'minitest'
require_relative '../ui.rb'
require_relative './test_ui_interface.rb'

def mock_ui_adapter
  MiniTest::Mock.new
end

def question_with_options(question)
  question += " (Y)es / (N)o / (Q)uit / (S)kip"
end

describe UI do
  include UIInterfaceTest
  
  before do
    @adapter = mock_ui_adapter
    @ui = UI.new(@adapter)
  end

  it "can tell the user something" do
    statement = "something"
    @adapter.expect :write, nil, [statement]
    @ui.tell(statement).must_be_nil
    @adapter.verify
  end

  it "can ask the user for input" do
    question = "Can you hear me now?"
    @adapter.expect :read, 'y', [question]
    @ui.ask(question).must_equal 'y'
    @adapter.verify
  end

  it "will return true if the user answers yes" do
    question = "Huh?"
    @adapter.expect :read, 'Yes', [question_with_options(question)]
    @ui.ask_yes_no(question).must_equal true
    @adapter.verify
  end

  it "will return false if the user answers no" do
    question = "Huh?"
    @adapter.expect :read, 'No', [question_with_options(question)]
    @ui.ask_yes_no(question).must_equal false
    @adapter.verify
  end

  it "will return nil if the user answers skip" do
    question = "Huh?"
    @adapter.expect :read, 'Skip', [question_with_options(question)]
    @ui.ask_yes_no(question).must_be_nil
    @adapter.verify
  end

  it "will quit if the user enters quit" do
    text = "Enter q or quit to exit."
    @adapter.expect :read, 'q', [text]
    ui = UI.new(@adapter)
    def ui.quit
      @adapter.verify.must_equal true
    end
    ui.ask(text)
  end
end
