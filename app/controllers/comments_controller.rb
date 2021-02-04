class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @course = Course.friendly.find(params[:course_id])
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @comment.lesson = @lesson
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html{redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully created.'}
      else
        format.html {redirect_to course_lesson_path(@course, @lesson), alert: 'Smt wrong! '}
      end
    end
  end

  def destroy
    @course = Course.friendly.find(params[:course_id])
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    authorize @comment
    respond_to do |format|
      format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Comment was successfully destroyed.' }
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
