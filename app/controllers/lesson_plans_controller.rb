class LessonPlansController < ApplicationController
  before_action :set_lesson_plan,
    only: [:show, :edit, :update, :destroy]
  before_action :set_standards, only: :edit

  def index
    search_params = [:sort, :direction, :search, :course]
    search = params.each_key.select { |p|
      search_params.include?(p.to_sym)
    }
    if search.empty?
      @lesson_plans = current_user.lesson_plans.
        paginate page: params[:page], per_page: 8
    else
      params.each.map do |k, v|
        if search_params.include?(k.to_sym)
          v.downcase! unless k.to_sym == :course
        end
      end
      @lesson_plans = LessonPlanQuery.new(
        current_user.lesson_plans).search(params).
          paginate page: params[:page], per_page: 8
    end
  end

  def show
    render layout: false
  end

  def new
    @lesson_plan = current_user.lesson_plans.
      new start: start_time, end: end_time
  end

  def edit
    if params[:search]
      @standards = CoreStandard.ordered.where.
        not(id: @lesson_plan.core_standards.ids).
        where('lower(description) like ? OR lower(dot_notation) like ?',
          "%#{params[:search].downcase}%", "%#{params[:search].downcase}%").
          paginate page: params[:page], per_page: 5

    end
  end

  def create
    @lesson_plan = current_user.lesson_plans.
      new(lesson_plan_params)
    if @lesson_plan.save
      flash[:notice] =
        'Lesson plan was successfully created.'
      redirect_to edit_lesson_plan_path(@lesson_plan)
    else
      flash[:error] =
        'Lesson plan failed to be created.'
      render :new
    end
  end

  def update
    if @lesson_plan.update(lesson_plan_params)
      respond_to do |format|
        format.html do
          flash[:notice] =
            'Lesson plan was successfully updated.'
          redirect_to edit_lesson_plan_path @lesson_plan
        end
        format.js
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] =
            'Lesson plan failed to be updated.'
          render :edit
        end
        format.js
      end
    end
  end

  def destroy
    if @lesson_plan.destroy
      flash[:notice] =
        'Lesson plan was successfully deleted.'
      redirect_to lesson_plans_path
    else
      flash[:notice] =
        'Lesson plan failed to be deleted.'
      render :edit
    end
  end

  private

  def set_lesson_plan
    @lesson_plan = current_user.lesson_plans.
      find(params[:id])
  end

  def set_standards
    @standards = CoreStandard.ordered.where.
      not(id: @lesson_plan.core_standards.ids).
      paginate page: params[:page], per_page: 5
  end

  def lesson_plan_params
    params.require(:lesson_plan).permit :course,
      :title, :start, :end, :body, :complete
  end

  def start_time
    @now ||= 8.hours.since Date.today.beginning_of_day
    @start_time ||= params.fetch(:start) { @now }.
      to_datetime
  end

  def end_time
    params.fetch(:end) { 1.hour.since(@now) }.
      to_datetime
  end

end
