class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:signup, :drop]
  before_action :authenticate_teacher!, except: [:signup, :drop, :student_signups]

  # POST /courses/signup.json
  def signup
    render json: {api_key: "Please provide an API key."}, status: :unauthorized and return unless params['api_key']
    render json: {api_key: "Invalid API key."}, status: :unauthorized and return unless params['api_key'] == ENV['API_KEY']
    @signup = Signup.new(signup_params)
    #ap @signup
    if @signup.save
      render json: @signup, status: :created
    else
      render json: @signup.errors, status: :unprocessable_entity
    end
  end

  # POST /courses/drop.json
  def drop
    render json: {api_key: "Please provide an API key."}, status: :unauthorized and return unless params['api_key']
    render json: {api_key: "Invalid API key."}, status: :unauthorized and return unless params['api_key'] == ENV['API_KEY']
    @signup = Signup.find_by(snum: params['drop']['snum'], course_id: params['drop']['course_id'])
    render json: {drop: "Not found"}, status: :unprocessable_entity and return unless @signup
    @signup.destroy
    render json: {drop: "Course dropped"}, status: :ok
  end

  # GET /student_signups?snum=...
  def student_signups
    render json: {api_key: "Please provide an API key."}, status: :unauthorized and return unless params['api_key']
    render json: {api_key: "Invalid API key."}, status: :unauthorized and return unless params['api_key'] == ENV['API_KEY']
    @signups = Signup.where(snum: params['snum'])
    @courses = @signups.map(&:course_id).sort
    render json: @courses
  end

  # GET /courses
  # GET /courses.json
  def index
    @courses = current_teacher.courses.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    redirect_to '/', alert: "Course belongs to different teacher." unless @course.teacher == current_teacher
  end

  # GET /courses/new
  def new
    @course = current_teacher.courses.new
  end

  # GET /courses/1/edit
  def edit
    redirect_to '/', alert: "Course belongs to different teacher." unless @course.teacher == current_teacher
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = current_teacher.courses.new(course_params)

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

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.teacher == current_teacher
        if @course.update(course_params)
          format.html { redirect_to @course, notice: 'Course was successfully updated.' }
          format.json { render :show, status: :ok, location: @course }
        else
          format.html { render :edit }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @course, alert: 'Forbidden. Course belongs to different teacher.' }
        format.json { render json: {forbidden: "Course belongs to different teacher."}, status: :forbidden }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    if @course.teacher == current_teacher
      @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to @course, alert: 'Forbidden. Course belongs to different teacher.' }
      format.json { render json: {forbidden: "Course belongs to different teacher."}, status: :forbidden }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:name, :ctype, :description, :ects, :limit)
  end

  def signup_params
    params.require(:signup).permit(:snum, :course_id, :first, :last)
  end
end
