class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  # GET /tasks
  # GET /tasks.json
  def index
    @labels = Hash[*Label.pluck(:title, :id).flatten]
    @tasks = current_user.tasks.order('created_at desc').page(params[:page]).per(5)

    #ソート
    #終了期限による降順ソート
    @tasks = @tasks.order('deadline desc') if params[:sort_expired].present?
    #優先順位による降順ソート
    @tasks = @tasks.order('priority desc') if params[:sort_priority].present?

    #絞り込み検索
    if params[:search]
      #タイトルによる絞り込み
      @tasks = @tasks.search_with_title(params[:title]) if params[:title].present?
      #ステータスによる絞り込み
      @tasks = @tasks.search_with_status(params[:status]) if params[:status].present?
      #ラベルによる絞り込み
      @tasks = @tasks.search_with_label(params[:label_id]) if params[:label_id].present?
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
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
      @labels = @task.labels
    end

    def set_label
      @label = Label.where(params[:label_ids])
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
