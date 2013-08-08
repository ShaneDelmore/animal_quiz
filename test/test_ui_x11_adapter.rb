require 'minitest'
require_relative 'test_ui_adapter.rb'
require_relative '../ui_x11_adapter.rb'

describe "UITextAdapter" do
  include UIAdapterTest

  before do
    @adapter = UIX11Adapter.new
  end
end


