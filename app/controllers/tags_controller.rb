class TagsController < ApplicationController

  # Для тегов нам нужен только 'ri Cjplfnm'
  def create
    # Создаем новый тег? используя параметры из переданных
    @tag = Tag.new(tag_params)
    if @tag.save  # если тег успешно сохранился
      render json: @tag # отрисовываем его
    else
      render json: { errors: @tag.errors.full_messages } # или покказываем ошибку
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

end
