class RankingsController < ApplicationController
  before_action :require_login
  def index
    @max_scores = KaraokeScore
                  .where(user_id: current_user.id)
                  .group(:song_id)
                  .maximum(:score)

    @song_titles = Song.where(id: @max_scores.keys).pluck(:id, :title).to_h
    @max_ranking = @max_scores.sort_by { |song_id, score| score }.reverse

    @average_scores = KaraokeScore
                      .where(user_id: current_user.id)
                      .group(:song_id)
                      .average(:score)

    @average_ranking = @average_scores.sort_by { |song_id, score| score }.reverse
    @song_counts = KaraokeScore
                    .where(user_id: current_user.id)
                    .group(:song_id)
                    .count(:song_id)
    @count_ranking = @song_counts.sort_by { |song_id, count| count }.reverse
  end
end
