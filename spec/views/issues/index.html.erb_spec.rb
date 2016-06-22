require 'rails_helper'

RSpec.describe "issues/index", type: :view do
  before(:each) do
    assign(:issues, [
      Issue.create!(
        :title => "Title",
        :url => "Url",
        :body => "MyText",
        :labels => "",
        :project => nil
      ),
      Issue.create!(
        :title => "Title",
        :url => "Url",
        :body => "MyText",
        :labels => "",
        :project => nil
      )
    ])
  end

  it "renders a list of issues" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
