require 'minitest'

#only needed when using minitest/spec to add DSL syntax to module.
class Module
  include Minitest::Spec::DSL
end

module UIAdapterTest
  it "responds to :write" do
    @adapter.must_respond_to :write
  end

  it "responds to :read" do
    @adapter.must_respond_to :read
  end
end
