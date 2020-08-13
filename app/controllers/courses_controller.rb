class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

# В Экшене прописываем дополнительно поиск
  def index
    # Если в параметрах передан заголовок, то ищем все курсыБ содержащие его
    if params[:title]
      # Запрос прописыывается вручную т.к. нужно частичное совпадение
      @courses = Course.where("title LIKE ?", "%#{params[:title]}%") # нечувствительно к заглавным
    else
      # Если параметров нет, то выводим полный список курсов
      @courses = Course.all

      # Выбираем всех узеров и сортируем по дате создания
      # Методы из gem ransack, которые формирует поисковую выдачу
      @q = Course.ransack(params[:q])
       # добавляем в результаты поиска userov
      @courses = @q.result.includes(:user)
    end
  end

  def show
  end

  def new
    @course = Course.new
  end


  def edit
  end


  def create
    @course = Course.new(course_params)
    # У каждого курса должен быть User? поэтому берем текущего (зарегистрированного)
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
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy
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
