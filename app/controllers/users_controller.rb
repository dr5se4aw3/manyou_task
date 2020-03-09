class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_login, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
=begin
  #一般ユーザーではユーザー一覧機能は使用できない
  #別途、管理者用コントローラーを作成し、そちらでは一覧機能を実装する
  def index
    @users = User.all
  end
=end
  # GET /users/1
  # GET /users/1.json
  def show
    if @user.id != current_user.id
      redirect_to user_path(current_user.id), notice: '他ユーザーの情報は閲覧できません。'
    end
  end

  # GET /users/new
  def new
    if logged_in?
      redirect_to user_path(current_user.id), notice: '既にログインしています。'
    end
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if @user.id != current_user.id
      redirect_to user_path(current_user.id), notice: '他ユーザーの情報は編集できません。'
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました。"
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.id != current_user.id
      redirect_to user_path(current_user.id), notice: '他ユーザーの情報は削除できません。'
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to new_user_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    def check_login
      if logged_in?
      else
        flash[:notice] = "ログインしてください"
        redirect_to new_session_path
      end
    end
end
