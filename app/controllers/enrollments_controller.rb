class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy, :certificate]
  # при создании новой подписки нам надо выбарть курс, на который будем подписываться
  before_action :set_course, only: [:new, :create]

  # Доступ к сертификату возможен без регистрации - для просмотра по прямой ссылке из PDF
  skip_before_action :authenticate_user!, only: [:certificate]

  def index
    # Для корректного поиска задаем , по которому будет пересылаться запрос из формы @q
    @ransack_path = enrollments_path

    # Методы из gem ransack, которые формирует поисковую выдачу
    @q = Enrollment.ransack(params[:q])

    # подключаем пагинацию и в нее вставляем массив, подготовленный для сортироваки в Ransack
    #  вот в оригинале @pagy, @records = pagy(Product.some_scope)
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    authorize @enrollments
  end

  # Список всех студентов данного преподователя
  def my_students
    # Для корректного поиска задаем , по которому будет пересылаться запрос из формы @q
    @ransack_path = my_students_enrollments_path
    # Нужно найти все курсы преподователя и в Их подписках найти ID всех пользователей ( студентов)
    # Мешанина из  Поиска и пагинации!!!!
    @q = Enrollment.joins(:course).where(courses: { user: current_user }).ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    render :index
  end

  # метод для формирования PDF сертификата
  def certificate
    # Сертификат можно посмотреть только если закончил курс на 100%
    # задаем это правило в policies
    authorize @enrollment, :certificate?
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@enrollment.course.title}, #{@enrollment.user.email}",
               page_size: "A4",
               # Содержание берется из course/show
               template: "enrollments/certificate.pdf.haml"
        # Часть настроек PDF шаблона перенесена в initialize/wicked_pdf и будет универсальна для любого фалй PDF на сайте
      end
    end
  end


  def show

  end

  def new
    @enrollment = Enrollment.new
  end

  def edit
    authorize @enrollment
  end

  def create
    # Создание новой подписки
    # елси Курс Платный
    if @course.price > 0
      # Оздаем новую оплату
      customer = Stripe::Customer.create(
          email: params[:stripeEmail],
          source: params[:stripeToken]
      )
      charge = Stripe::Charge.create(
          customer: customer.id,
          amount: (@course.price * 100).to_i,
          description: @course.title,
          currency: "usd"
      )
    end
    # Если курс Оплачен/подписан
    # то для текущего пользователя делаем метод ПОКУПКА = создаем запись Подписка
    @enrollment = current_user.buy_course(@course)
    # и редиректим на страницу курса
    redirect_to course_url(@course), notice: "You are enrolled!"
    # При новой подписке рассылаем письмо владельцу курса и студенту
    EnrollmentMailer.student_enrollment(@enrollment).deliver_now
    EnrollmentMailer.teacher_enrollment(@enrollment).deliver_now
    # редирект в случае неудачной оплаты
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_course_enrollment_path(@course)
  end

  def update
    authorize @enrollment
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: 'Enrollment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @enrollment
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def set_enrollment
    @enrollment = Enrollment.friendly.find(params[:id])
  end

  def enrollment_params
    # убрали из параметров user и course ID, т.к. они явно передаются в каждом методе
    params.require(:enrollment).permit(:rating, :review)
  end

end
