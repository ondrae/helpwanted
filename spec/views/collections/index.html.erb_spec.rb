require 'rails_helper'

RSpec.describe "collections/index", type: :view do
  before(:each) do
    assign(:collections, [
      Collection.create!(
        :name => "Name",
        :description => "MyText"
      ),
      Collection.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of collections" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
