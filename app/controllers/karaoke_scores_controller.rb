class KaraokeScoresController < ApplicationController
  before_action :require_login
  def index
    @q = current_user.karaoke_scores.ransack(params[:q])
    @karaoke_scores = @q.result
  end

  def new
    @karaoke_score = KaraokeScore.new
  end

  def create
    @karaoke_score = current_user.karaoke_scores.build(karaoke_score_params)

    if @karaoke_score.save
      redirect_to karaoke_scores_path, notice: "採点結果を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @karaoke_score = current_user.karaoke_scores.find(params[:id])
  end

  def edit
    @karaoke_score = current_user.karaoke_scores.find(params[:id])
    @karaoke_score.artist_name = @karaoke_score.song.artist.name
    @karaoke_score.song_title = @karaoke_score.song.title
  end

  def update
    @karaoke_score = current_user.karaoke_scores.find(params[:id])

    if @karaoke_score.update(karaoke_score_params)
      redirect_to @karaoke_score, notice: "採点結果を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @karaoke_score = current_user.karaoke_scores.find(params[:id])
    @karaoke_score.destroy

    redirect_to karaoke_scores_path, notice: "採点結果を削除しました"
  end

  private

  def karaoke_score_params
    params.require(:karaoke_score).permit(
      :artist_name,
      :song_title,
      :score,
      :karaoke_machine,
      :sung_at,
      :memo,
      :score_image
    )
  end
end
