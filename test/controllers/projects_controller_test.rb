class ProjectsControllerTest < ActionController::TestCase
  def setup
    CASClient::Frameworks::Rails::Filter.logout(ProjectsController)
  end
  # Before each, logout of CAS
  test "should redirect to CAS page" do
    get :index
    assert_response :success
  end

  test "should allow access with CAS login" do
    CASClient::Frameworks::Rails::Filter.fake("fak23")
    get :index
    assert_response :success
    assert_equal session[:cas_user], "fak23"
  end 
end