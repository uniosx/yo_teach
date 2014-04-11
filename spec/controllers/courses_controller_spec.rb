require 'spec_helper'

describe CoursesController do
  let(:account) { FactoryGirl.create :account }
  let(:user) { FactoryGirl.create :user,
    account: account }

  before do
    request.session[:user_id] = user.id
  end

  describe "GET #index" do
    it "populates an array of courses" do
      course = FactoryGirl.create :course, user: user
      get :index
      assigns(:courses).should eq([course])
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET #new" do
    it "assigns a new Course to @course" do
      get :new
      assigns(:course).should be_a_new(Course)
    end

    it "renders the :new template" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new course" do
        expect{
          post :create, course:
            FactoryGirl.attributes_for(:course)
        }.to change(Course,:count).by(1)
      end

      it "redirects to the courses page" do
        post :create, course:
          FactoryGirl.attributes_for(:course)
        response.should redirect_to courses_path
      end
    end

    context "with invalid attributes" do
      it "does not save the new contact in the database" do
        expect{
          post :create, course:
            FactoryGirl.attributes_for(:invalid_course)
        }.to_not change(Course, :count)
      end

      it "re-renders the :new template" do
        post :create, course:
          FactoryGirl.attributes_for(:invalid_course)
        response.should render_template :new
      end
    end
  end

  describe "POST #delete" do
    it "renders the destroy template" do
      course = FactoryGirl.create :course, user: user
      delete :destroy, id: course.id
      response.should redirect_to courses_path
    end

    it "deletes the course" do
      course = FactoryGirl.create :course, user: user
      expect{
        delete :destroy, id: course.id
      }.to change(Course, :count).by(-1)
    end
  end

end
