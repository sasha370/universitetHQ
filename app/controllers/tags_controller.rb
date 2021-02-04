class TagsController < ApplicationController
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag
    else
      render json: { errors: @tag.errors.full_messages }
    end
  end

  def index
    @tags = Tag.all.order(course_tags_count: :desc)
    authorize @tags
  end

  def destroy
    @tag = Tag.find(params[:id])
    authorize @tag
    if @tag.destroy
      flash.now[:notice] = "Tag was success remove!"
      redirect_to tags_path
    else
      flash.now[:alert] = "Something wrong!"
      redirect_to tags_path
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :id)
  end

end
