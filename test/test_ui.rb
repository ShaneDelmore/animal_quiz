require 'minitest'

#only needed when using minitest/spec to add DSL syntax to module.
class Module
  include Minitest::Spec::DSL
end

module UITest
  #Rework this to be only an adapter and respond to push and pull.
  #Move logic into main UI module.
  it "responds to :tell" do
    @ui.must_respond_to :tell
  end

  it "responds to :ask" do
    @ui.must_respond_to :tell
  end

  it "responds to :get_input" do
    @ui.must_respond_to :get_input
  end

  it "responds to :get_input_to_bool" do
    @ui.must_respond_to :get_input_to_bool
  end

  it "responds to :ask_yes_no" do
    @ui.must_respond_to :ask_yes_no
  end

end
