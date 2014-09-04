require 'rails_helper'

RSpec.describe "projects/new", :type => :view do
  before(:each) do
    assign(:project, Project.new(
      :name => "MyString",
      :description => "MyText",
      :photo_url => "MyString"
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input#project_name[name=?]", "project[name]"

      assert_select "textarea#project_description[name=?]", "project[description]"

      assert_select "input#project_photo_url[name=?]", "project[photo_url]"
    end
  end
end
