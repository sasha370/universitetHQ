class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :approve, :unapprove, :analytics]
  # Скипаем проверку для всех, чтобы незарегистрированный мог просматривать Курс
  skip_before_action :authenticate_user!, only: [:show]


  # В Экшене прописываем дополнительно поиск
  def index
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    # Для корректного поиска задаем , по которому будет пересылаться запрос из формы @q
    @ransack_path = courses_path
    # Переменная для Поиска в навбаре ( повторяется в AppController)
    # Отображаем в результатах только опубликованные курсы
    # В то время как для Купленных, Созданных, С отзывами и т.д. у нас есть другие методы( ниже)
    # Таким образом только на Index будет список Опубликованных и Подтвержденных курсов
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    # @courses = @ransack_courses.result.includes(:user)   ПРИМЕР

    # подключаем пагинацию
    # ПРИМЕР  @pagy, @records = pagy(Product.some_scope)
    #  :course_tags, :course_tags => :tags)  так реализуется зависимости has_many - trouth
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :course_tags => :tag))
  end

  # Купленные курсы. Объеденяем все курсы в которых есть  Подписка с текущим пользователем
  def purchased
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    # Для корректного поиска задаем путь , по которому будет пересылаться запрос из формы @q
    @ransack_path = purchased_courses_path

    # Переменная для Поиска в навбаре ( повторяется в AppController)
    @ransack_courses = Course.joins(:enrollments).where(enrollments: { user: current_user }).ransack(params[:courses_search], search_key: :courses_search)
    # И добавляем к выборке пагинацию
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  # Ожидающие отзыва курсы
  def pending_review
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    # Для корректного поиска задаем  путь, по которому будет пересылаться запрос из формы @q
    @ransack_path = pending_review_courses_path
    # В COURSES выбрать все подписки в которых есть Подписки, в которых нет еще отзывов (scope из enrollment.rb) текущего пользователя
    #  # Переменная для Поиска в навбаре ( повторяется в AppController)
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)
    # И добавляем к выборке пагинацию
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  # Курсы, которые создал пользователь
  def created #teaching
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    # Для корректного поиска задаем  путь, по которому будет пересылаться запрос из формы @q
    @ransack_path = created_courses_path
    #  # Переменная для Поиска в навбаре ( повторяется в AppController)
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)

    # Выбираем все курсы, где автор - текущий пользователь
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index
  end

  # Обработчик аналитики для каждого отдельного курса.
  def analytics
    authorize @course, :owner?
  end


  # Поддтвердить и снять для Курсов( функционал  Админа)
  def approve
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    # Метод из Pundit? задает права на редактирование только определенным. Прописано в policies
    authorize @course, :approve?
    @course.update_attribute(:approved, true)
    redirect_to @course, notice: "Course Approved!"
  end

  def unapprove
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    # Метод из Pundit? задает права на редактирование только определенным. Прописано в policies
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to @course, notice: "Course Unapproved and hidden!"
  end

  # Курсы, которые требуют подтверждения ( Для Админа)
  def unapproved
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    # Для корректного поиска задаем  путь, по которому будет пересылаться запрос из формы @q
    @ransack_path = unapproved_courses_path
    # В COURSES выбрать все подписки в которых есть Подписки, в которых нет еще отзывов (scope из enrollment.rb) текущего пользователя
    #  # Переменная для Поиска в навбаре ( повторяется в AppController)
    @ransack_courses = Course.unapproved.ransack(params[:courses_search], search_key: :courses_search)
    # И добавляем к выборке пагинацию
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render :index

  end


  def show
    authorize @course
    @lessons = @course.lessons.rank(:row_order).all # приписка для ранжирования по порядку
    @enrollments_with_reviews = @course.enrollments.reviewed

    # Выборка Похожих курсов
    @courses = [] # пустой массив для хранения выборки
    Course.all.where.not(id: @course.id).each do |course|
      # выбираем все курсы, кроме текущего
      # Ищем совпадение в ID тегов у текущего курса и у перебираемых
      # Считаем их, и если собпадение >0, то добавляем курс в список похожих
      if @course.tags.pluck(:id).intersection(course.tags.pluck(:id)).count > 0
        @courses.push(course) # во вьюхе уже отрисовываем полученный массив
      end
    end
  end

  def new
    @course = Course.new
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    authorize @course
  end

  # Перенесено в Wizard
  # def edit
  #   @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  #   # Метод из Pundit? задает права на редактирование только определенным. Прописано в policies
  #   authorize @course
  # end


  def create
    @course = Course.new(course_params)
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
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

  # Перенесено в Wizard
  # def update
  #   authorize @course
  #   respond_to do |format|
  #     if @course.update(course_params)
  #       format.html { redirect_to @course, notice: 'Course was successfully updated.' }
  #     else
  #       @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  #       format.html { render :edit }
  #     end
  #   end
  # end


  def destroy
    authorize @course
    # При удалении проверяем на ошибки. Если у курса нет зависимостей( подписок и т.д.), то ошибок не :будет
    # Это прописанно в моделе has_many :enrollments, dependent: :restrict_with_error
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      end
    else
      # Если есть зависимости, то удаление неудачное = есть ошибки
      redirect_to @course, alert: "Course has enrollments. Can not be destroyed"
    end
  end

  private

  def set_course
    # Поиск по базе производим не по полю ID, а по дружественному ID
    @course = Course.friendly.find(params[:id])
  end


  def course_params
    # White-list для параметров
    #  published - галочка для "опубликовать"
    # avatar  - прикрепленное изображение для аватарки, хранится на S3
    params.require(:course).permit(:title, :description, :short_description, :price, :level, :language, :published, :avatar, tag_ids: [])
  end
end
