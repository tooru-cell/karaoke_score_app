class SongMemosController < ApplicationController
  before_action :require_login
  def index
    @song_memos = current_user.song_memos.order(created_at: :desc)
    @song_memo = current_user.song_memos.build
  end

  def create
    @song_memo = current_user.song_memos.build(song_memo_params)

    if @song_memo.save
      redirect_to song_memos_path
    else
      @song_memos = current_user.song_memos.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @song_memo = current_user.song_memos.find(params[:id])
    @song_memo.destroy
    redirect_to song_memos_path
  end

  private

  def song_memo_params
    params.require(:song_memo).permit(:song_title, :artist_name)
  end
end
