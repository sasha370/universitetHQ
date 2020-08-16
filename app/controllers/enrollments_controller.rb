class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]

  # при создании новой подписки нам надо выбарть курс, на который будем подписываться
  before_action :set_course, only: [:new, :create]

  def index
    @enrollments = Enrollment.all
    # @course = current_user.courses
    authorize @enrollments
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
    # елси цена курса больше нуля
    if @course.price > 0
      #пока заглушка
      flash[:alert] = "You can not acess paid courses yet"
      redirect_to new_course_enrolment_url(@course) # редирект на новeю подписку
    else
      # Если курс бесплатный
      # то для текущего пользователя делаем метод ПОКУПКА = создаем запись Подписка
      @enrollment = current_user.buy_course(@course)
      # и редиректим на страницу курса
      redirect_to course_url(@course), notice: "You are enrolled!"
    end
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
