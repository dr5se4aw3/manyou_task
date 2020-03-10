class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end
  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    if logged_in?
      redirect_to admin_user_path(current_user.id), notice: '既にログインしています。'
    end
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました。"
      redirect_to admin_user_path(@user.id)
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user.id), notice: 'ユーザー情報の更新が完了しました'
      else
        render :edit
      end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      redirect_to admin_users_path, notice: 'ユーザーの削除が完了しました'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
    def check_admin
      if admin_user?
      else
        flash[:notice] = "管理者権限がありません"
        redirect_to new_session_path
      end
    end
end
