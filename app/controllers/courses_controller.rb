class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def show
  end

  def edit
	end

  def create
    @course = Course.new course_params(params[:course])
    if @course.save
      flash[:notice] = 'Course was successfully created.' 
      redirect_to courses_path
    else
      render action: :new
    end
  end

  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to courses_path, 
        							notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @course.errors, 
        							status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @course.destroy
			respond_to do |format|
				flash[:notice] = 'Course deleted successfully' 
				format.html { redirect_to courses_path }
				format.json { head :no_content }
			end
		end
  end

  private
    def set_course
      @course = Course.find(params[:id])
    end

    def course_params(params) 
      params.permit(:name, :start_date, :end_date)
    end
end
