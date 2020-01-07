class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]
  before_action :set_course,  only: [:new, :create, :index]
  before_action :authenticate_teacher!

  # GET /courses/:id/sessions
  # GET /courses/:id/sessions.json
  def index
    redirect_to '/', alert: 'Forbidden. Course belongs to a different teacher' unless @course.teacher == current_teacher
    @sessions = @course.sessions.all
  end

  # GET /courses/:id/sessions/1
  # GET /courses/:id/sessions/1.json
  def show
    redirect_to '/', alert: 'Forbidden. Course belongs to a different teacher' unless @session.course.teacher == current_teacher
  end

  # GET /courses/:id/sessions/new
  def new
    redirect_to '/', alert: 'Forbidden. Course belongs to a different teacher' unless @course.teacher == current_teacher
    @session = @course.sessions.new
  end

  # GET /courses/:id/sessions/1/edit
  def edit
    redirect_to '/', alert: 'Forbidden. Course belongs to a different teacher' unless @session.course.teacher == current_teacher
  end

  # POST /courses/:id/sessions
  # POST /courses/:id/sessions.json
  def create
    @session = Session.new(session_params)
    redirect_to '/', alert: 'Forbidden. Course belongs to a different teacher' unless @session.course.teacher == current_teacher
    respond_to do |format|
      if @session.save
        format.html { redirect_to @course, notice: 'Session was successfully created.' }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/:id/sessions/1
  # PATCH/PUT /courses/:id/sessions/1.json
  def update
    redirect_to '/', alert: 'Forbidden. Course belongs to a different teacher' unless @session.course.teacher == current_teacher
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to @session, notice: 'Session was successfully updated.' }
        format.json { render :show, status: :ok, location: @session }
      else
        format.html { render :edit }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/:id/sessions/1
  # DELETE /courses/:id/sessions/1.json
  def destroy
    @session.destroy
    respond_to do |format|
      format.html { redirect_to sessions_url, notice: 'Session was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:session).permit(:description, :location, :when, :course_id)
    end
end
