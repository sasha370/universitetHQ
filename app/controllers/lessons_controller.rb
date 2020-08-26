class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy, :delete_video]


  # Удалять вложенное видео
  def delete_video
    authorize @lesson, :edit?
    # Метод purge удаляет вложения из ActiveStarage - прописаано в документации
    @lesson.video.purge
    @lesson.video_thumbnail.purge
    redirect_to edit_course_lesson_path(@course,@lesson), notice: "Video Deleted!"
  end


  # Метод для обработки сортировки. нам нужно обновить значение Rank при каждом перетаскивании
  def sort
    @course = Course.friendly.find(params[:course_id])
    # в параметрах ловим именно lesson_id. который передается с помощью созданного DIVa
    lesson = Lesson.friendly.find(params[:lesson_id])
    authorize lesson, :edit?  # доступно только с правами на редактирование
    lesson.update(lesson_params) # обновляем массив params
    render body: nil # запрещаем перерисовывать
  end

  def index
    @lessons = Lesson.all
  end

  def show
  # Если пользователь Увидел Урок, то создается запись в User_lesson
    authorize @lesson # авторизация на просмотр  только у хозяина курса и админа
    current_user.view_lesson(@lesson)
    # Выбираем все уроки данного курса, курс достали из set_lesson
    @lessons = @course.lessons.rank(:row_order) # ранжируем по порядку

    # Т.к. мы будеим показывать коменты только внутри урока, то прописваем только в SHOW
    @comment = Comment.new
    @comments = @lesson.comments.order(created_at: :desc)
  end

  def new
    @lesson = Lesson.new
    @course = Course.friendly.find(params[:course_id])
  end

  def edit
    authorize @lesson # авторизация на редактирование только у хозяина курса
    @course = Course.friendly.find(params[:course_id])
  end

  def create
    @lesson = Lesson.new(lesson_params)
    @course = Course.friendly.find(params[:course_id])
    @lesson.course_id = @course.id
    authorize @lesson # авторизация на создание только у хозяина курса
    respond_to do |format|
      if @lesson.save
        format.html { redirect_to course_lesson_url(@course, @lesson), notice: 'Lesson was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @lesson # авторизация на редактирование только у хозяина курса
    @course = Course.friendly.find(params[:course_id])
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to course_lesson_url(@course, @lesson), notice: 'Lesson was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @lesson # авторизация на удаление только у хозяина курса
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to course_url(@course), notice: 'Lesson was successfully destroyed.' }
    end
  end

  private
    def set_lesson
      @course = Course.friendly.find(params[:course_id])
      @lesson = Lesson.friendly.find(params[:id])
    end

    def lesson_params
      # row_order_position - данные из сортировки c помощью JS на странице Курса
      params.require(:lesson).permit(:title, :content, :row_order_position, :video, :video_thumbnail)
    end
end
