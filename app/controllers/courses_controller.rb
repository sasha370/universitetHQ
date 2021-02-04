class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :approve, :unapprove, :analytics]
  skip_before_action :authenticate_user!, only: [:show]

  def index
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :course_tags => :tag))
  end

  def purchased
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    @ransack_path = purchased_courses_path
    @ransack_courses = Course.joins(:enrollments).where(enrollments: { user: current_user }).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  def pending_review
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  def created
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    @ransack_path = created_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  def analytics
    authorize @course, :owner?
  end

  def approve
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    authorize @course, :approve?
    @course.update_attribute(:approved, true)
    redirect_to unapproved_courses_path, notice: "Course Approved!"
  end

  def unapprove
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to unapproved_courses_path, notice: "Course Unapproved and hidden!"
  end

  def unapproved
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.unapproved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  def show
    authorize @course
    @lessons = @course.lessons.rank(:row_order).all
    @enrollments_with_reviews = @course.enrollments.reviewed
    @courses = []
    Course.all.where.not(id: @course.id).each do |course|
      if @course.tags.pluck(:id).intersection(course.tags.pluck(:id)).count > 0
        @courses.push(course)
      end
    end
  end

  def new
    @course = Course.new
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    @course.description = "Curriculum Description"
    @course.marketing_description = "Marketing Description"

    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    authorize @course
    @course.user = current_user

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_course_wizard_index_path(@course), notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @course
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      end
    else
      redirect_to @course, alert: "Course has enrollments. Can not be destroyed"
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :marketing_description, :price, :level, :language, :published, :avatar, tag_ids: [])
  end
end
