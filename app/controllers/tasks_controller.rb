class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  # GET /tasks
  # GET /tasks.json
  def index
    #@tasks = Task.all.order('created_at desc')
    #@tasks = Task.page.(params[:page]).per(PER)
    @tasks = current_user.tasks.order('created_at desc').page(params[:page]).per(5)
    #終了期限による降順ソート
    if params[:sort_expired]
      @tasks = current_user.tasks.order('deadline desc').page(params[:page]).per(5)
    end
    #優先順位による降順ソート
    if params[:sort_priority]
      @tasks = current_user.tasks.order('priority desc').page(params[:page]).per(5)
    end
    #タイトルおよび状態による絞り込み
    if params[:search]
      if params[:title].present? && params[:status].present?
        @tasks = current_user.tasks.search_with_title_status(params[:title], params[:status]).page(params[:page]).per(5)
      elsif params[:title].present?
        @tasks = current_user.tasks.search_with_title(params[:title]).page(params[:page]).per(5)
      elsif params[:status].present?
        @tasks = current_user.tasks.search_with_status(params[:status]).page(params[:page]).per(5)
      else
        @tasks = current_user.tasks.page(params[:page]).per(5)
      end
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @labels = @task.labels
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task.label_on_tasks.build
    @labels = Label.all
  end

  # GET /tasks/1/edit
  def edit
    if @task.user_id != current_user.id
      redirect_to tasks_path, notice: '他ユーザーのタスクは編集できません。'
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.build(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    if @task.user_id != current_user.id
      redirect_to tasks_path, notice: '他ユーザーのタスクは削除できません。'
    end
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :detail, :deadline, :status, :priority, label_ids: [])
    end

    def check_login
      if logged_in?
      else
        flash[:notice] = "ログインしてください"
        redirect_to new_session_path
      end
    end
end
