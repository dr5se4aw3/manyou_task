class Admin::LabelsController < ApplicationController
  before_action :set_label, only: [:destroy]
  #before_action :check_admin
  # GET /labels
  # GET /labels.json
  def index
    @labels = Label.all
  end
  # GET /labels/1
  # GET /labels/1.json
  def show
  end

  # GET /labels/new
  def new
    @label = Label.new
  end

  # GET /labels/1/edit
  def edit
  end

  # POST /labels
  # POST /labels.json
  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:notice] = "ラベル作成が完了しました。"
      redirect_to admin_labels_path
    else
      render :new
    end
  end

  # PATCH/PUT /labels/1
  # PATCH/PUT /labels/1.json
  def update
  end

  # DELETE /labels/1
  # DELETE /labels/1.json
  def destroy
    if @label.destroy
      redirect_to admin_labels_path, notice: 'ラベルの削除が完了しました'
    else
      flash[:notice] = 'ラベルの削除に失敗しました。'
      redirect_to admin_labels_path
    end
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end
  # Only allow a list of trusted parameters through.
  def label_params
    params.require(:label).permit(:title)
  end

  def check_admin
    if logged_in?
      if admin_label?
      else
        begin
          raise AuthorityError
        rescue => e
          flash[:notice] = "#{e}：管理者権限がありません"
          redirect_to label_path(current_label.id)
        end
      end
    else
      flash[:notice] = "ログインしてください"
      redirect_to new_session_path
    end
  end
end
