class LabelOnTasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def show
    @labels_on_task = @task.related_labels
  end

  def create
    label = @task.favorites.create(post_id: params[:post_id])
    redirect_to posts_url, notice: "#{favorite.post.user.name}さんの投稿をお気に入り登録しました"
  end

  def destroy
    favorite = current_user.favorites.find_by(id: params[:id]).destroy
    redirect_to posts_url, notice: "#{favorite.post.user.name}さんの投稿をお気に入り解除しました"
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end
end
