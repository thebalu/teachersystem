class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :course]
  skip_before_action :verify_authenticity_token, only: [:signup, :drop]
  before_action :authenticate_teacher!, except: [:signup, :drop, :student_signups, :index, :show]

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

  def id_signup
    @course = Course.find(params[:course_id])
    redirect_to '/', alert: "Course belongs to different teacher." unless @course.teacher == current_teacher

    #puts 'Making a request to Jordans slow af server'
    #response = HTTParty.get('http://uni.finchyy.co.uk/resources/api/user?userId=1', verify:false)
    #puts 'Finally...'
    #response.body.slice! 0..5
    #parsed = JSON.parse response.body

    mock = "{\"UserID\":\"1\",\"FirstName\":\"Jordan\",\"LastName\":\"Finchjhjhhj\",\"Email\":\"jordan.e.finch@gmail.com\",\"PhoneNumber\":\"+447492867569\",\"SessionID\":\"8f88ea3fae09ebd6a196c21c7a233c48\",\"StudentID\":\"1\",\"Degree\":\"BSc. Computer Science\",\"Address\":\"Julius-Raab-Strasse 1-3\",\"TeacherID\":null,\"Office\":null,\"Bills\":[{\"UserID\":\"1\",\"BillID\":\"1\"},{\"UserID\":\"1\",\"BillID\":\"2\"}],\"Loans\":[{\"UserID\":\"1\",\"LoanID\":\"1\"},{\"UserID\":\"1\",\"LoanID\":\"3\"}]}"
    parsed = JSON.parse mock
    ap parsed

    @signup = Signup.new(course: @course, snum: params[:student_id], first: parsed['FirstName'], last: parsed['LastName'])

    if @signup.save
      redirect_to @course, notice: "Successfully signed up student with id: #{params[:student_id]}."
    else
      redirect_to @course, alert: "Error while signing up student with id: #{params[:student_id]}. Errors: #{@signup.errors.full_messages}"
    end
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
    @courses = teacher_signed_in? ? current_teacher.courses.all : Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    #redirect_to '/', alert: "Course belongs to different teacher." unless @course.teacher == current_teacher
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