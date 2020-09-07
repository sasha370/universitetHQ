class Courses::CourseWizardController < ApplicationController
  # Подключаем гем внутри именно этого контроллера
  include Wicked::Wizard

  before_action :set_progress, only: [:show, :update]
  before_action :set_course, only: [:show, :update, :finish_wizard_path]
  # разбиваем Мультиформу на два шага и даем им названия
  # В первой Title description аватар
  # во второй язык, цена и т.п.
  steps :basic_info, :details, :lessons, :publish

  def show
    # авторизвуем по курсу и его политике на Edit
    authorize @course, :edit?
    case step
      when :basic_info
      when :details
        @tags = Tag.all
      when :lessons
        unless @course.lessons.any?
          @course.lessons.build
        end
      when :publish

    end
    render_wizard
  end

  def update
    authorize @course, :edit?
    @course.update_attributes(course_params)
    case step
      when :basic_info
      when :details
        @tags = Tag.all
      when :lessons
      when :publish
    end
    render_wizard @course
  end


  # Путь по которому переходим, когда форма заполенна
  def finish_wizard_path
    authorize @course, :edit?
    course_path(@course)
  end

  private

  # счетчик прогресса заполнения формы
  def set_progress
    # Если есть хоть один шаг и у нас есть текущий шаг
    if wizard_steps.any? && wizard_steps.index(step).present?
      @progress = ((wizard_steps.index(step) + 1).to_d / wizard_steps.count.to_d) * 100
    else
      @progress = 0
    end
  end

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :short_description, :price, :level, :language, :published,
                                   :avatar, tag_ids: [],  lessons_attributes: [:id, :title, :content, :_destroy])
  end
end
