require 'rails_helper'

RSpec.describe MainController, :type => :controller do
  describe "No CAS authentication" do
    # TODO: figure out how to log out of CAS in tests
    # before(:each) do
    #   session[:cas_user] = nil
    #   redirect_to "https://secure.its.yale.edu/cas/logout"
    # end
    # it "shows index even without CAS login" do
    #   get :index
    #   expect(response).to render_template(:index)
    # end

    # it "goes to CAS on login" do
    #   CAS_PATH = "https://secure.its.yale.edu/cas/login?service=http%3A%2F%2Ftest.host%2Flogin"
    #   get :login
    #   expect(response).to redirect_to CAS_PATH
    # end
  end

  describe "CAS Logged in" do
    before(:each) do
      session[:cas_user] = "fak23"
      CASClient::Frameworks::Rails::Filter.fake("fak23")
    end

    it "shows index" do
      get :index
      expect(response).to render_template(:index)
    end

    it "skips CAS on login" do
      get :login
      expect(response).to redirect_to root_path
    end

    it "allows destroying user" do
      # expect(session[:cas_user]).to_not be_nil
      get :destroy
      expect(session[:cas_user]).to be_nil
      expect(response).to redirect_to root_path
    end
  end
end

