class CourseCreatorController < ApplicationController
  # Подключаем гем внутри именно этого контроллера
  include Wicked::Wizard

  before_action :set_progress, only: [:show]

  # разбиваем Мультиформу на два шага и даем им названия
  # В первой Title description аватар
  # во второй язык, цена и т.п.
  steps :basic_info, :details

  def show
    render_wizard
  end

  # Путь по которому переходим, когда форма заполенна
  def finish_wizard_path
    courses_path
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
end
