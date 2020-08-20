class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

# В Экшене прописываем дополнительно поиск
  def index
    # Для корректного поиска задаем , по которому будет пересылаться запрос из формы @q
    @ransack_path = courses_path

    # Переменная для Поиска в навбаре ( повторяется в AppController)
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search)
    # @courses = @ransack_courses.result.includes(:user)

    # подключаем пагинацию
    #  вот в оригинале @pagy, @records = pagy(Product.some_scope)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
  end

# Купленные курсы. Объеденяем все курсы в которых есть  Подписка с текущим пользователем
  def purchased
    # Для корректного поиска задаем , по которому будет пересылаться запрос из формы @q
    @ransack_path = purchased_courses_path
    # Переменная для Поиска в навбаре ( повторяется в AppController)
    @ransack_courses = Course.joins(:enrollments).where(enrollments: { user: current_user }).ransack(params[:courses_search], search_key: :courses_search)
    # И добавляем к выборке пагинацию
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

# Ожидающие отзыва курсы
  def pending_review
    # Для корректного поиска задаем , по которому будет пересылаться запрос из формы @q
    @ransack_path = pending_review_courses_path
    # В COURSES выбрать все подписки в которых есть Подписки, в которых нет еще отзывов (scope из enrollment.rb) текущего пользователя
    #  # Переменная для Поиска в навбаре ( повторяется в AppController)
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)
    # И добавляем к выборке пагинацию
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

# Курсы, которые создал пользователь
  def created
    # Для корректного поиска задаем , по которому будет пересылаться запрос из формы @q
    @ransack_path = created_courses_path
    #  # Переменная для Поиска в навбаре ( повторяется в AppController)
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)

    # Выбираем все курсы, где автор - текущий пользователь
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  def show
    @lessons = @course.lessons
    @enrollments_with_reviews = @course.enrollments.reviewed
  end

  def new
    @course = Course.new
    authorize @course
  end


  def edit
    # Метод из Pundit? задает права на редактирование только определенным. Прописано в policies
    authorize @course
  end


  def create
    @course = Course.new(course_params)
    # У каждого курса должен быть User? поэтому берем текущего (зарегистрированного)
    authorize @course
    @course.user = current_user
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy
    authorize @course
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
    end
  end

  private

  def set_course
    # Поиск по базе производим не по полю ID, а по дружественному ID
    @course = Course.friendly.find(params[:id])
  end


  def course_params
    params.require(:course).permit(:title, :description, :short_description, :price, :level, :language)
  end
end
