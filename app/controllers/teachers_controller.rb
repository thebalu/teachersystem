class TeachersController < ApplicationController

  before_action :authenticate_teacher!, only: [:show, :edit, :update]

  def show
  end

  def edit
    @teacher = current_teacher
    render 'edit', locals: {teacher: @teacher}
  end

  def update
    @teacher = current_teacher
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to show_teacher_path, notice: 'Info was successfully updated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_teacher
    render json: {api_key: "Please provide an API key."}, status: :unauthorized and return unless params['api_key']
    render json: {api_key: "Invalid API key."}, status: :unauthorized and return unless params['api_key'] == ENV['API_KEY']
    @teacher = Teacher.find_by(tnum:params['tnum'])
    if @teacher
      render json: {teacher: {tnum: @teacher.tnum, first: @teacher.first, last: @teacher.last }}, status: :found #302
    else
      render json: {not_found: "Teacher with given number not found."}, status: :not_found #404
    end
  end

  private
  def teacher_params
    params.require(:teacher).permit(:first,:last,:office,:email)
  end
end