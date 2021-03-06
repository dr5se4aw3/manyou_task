class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_admin
  # GET /users
  # GET /users.json
  def index
    @users = User.all.includes(:tasks).order('id')
  end
  # GET /users/1
  # GET /users/1.json
  def show
    @tasks = @user.tasks
  end

  # GET /users/new
  def new
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
      flash[:notice] = "ユーザー登録が完了しました(管理者画面)。"
      redirect_to admin_users_path
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
        flash[:notice] = '管理者は最低一人必要なため権限を剥奪できません'
        redirect_to admin_users_path
      end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy

    if @user.destroy
      redirect_to admin_users_path, notice: 'ユーザーの削除が完了しました'
    else
      flash[:notice] = '管理者は最低一人必要なため削除できません'
      redirect_to admin_users_path
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
      if logged_in?
        if admin_user?
        else
          begin
            raise AuthorityError
          rescue => e
            flash[:notice] = "#{e}：管理者権限が無いためアクセスできません。"
            redirect_to user_path(current_user.id)
          end
        end
      else
        flash[:notice] = "ログインしてください"
        redirect_to new_session_path
      end
    end
end
