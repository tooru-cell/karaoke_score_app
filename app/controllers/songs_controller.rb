class SongsController < ApplicationController
  before_action :require_login

  def show
    @song = Song.find(params[:id])

    @scores = current_user.karaoke_scores
                          .where(song: @song)
                          .order(sung_at: :desc)

    @highest_score = @scores.maximum(:score)
    @average_score = @scores.average(:score)
    @sing_count = @scores.count

    if @scores.count >= 2
      @difference = @scores.first.score - @scores.second.score
    end
  end
end
