class StaticPagesController < ApplicationController
  before_action :require_login, only: [:summary]

  def top
  end

  def summary
    scores = current_user.karaoke_scores

    @average_score = scores.average(:score)
    @max_score = scores.maximum(:score)
    @min_score = scores.minimum(:score)
    @total_scores = scores.count
    @total_songs = scores.distinct.count(:song_id)

    @recent_scores = scores
                     .includes(song: :artist)
                     .order(sung_at: :desc, id: :desc)
                     .limit(3)

    
  @trophies = {
    score_90: @max_score.to_f >= 90,
    score_95: @max_score.to_f >= 95,
    score_100: @max_score.to_f >= 100,
    count_10: @total_scores >= 10,
    songs_10: @total_songs >= 10
  }

  end
end