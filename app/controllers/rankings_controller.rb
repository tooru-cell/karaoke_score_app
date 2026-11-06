
class RankingsController < ApplicationController
  before_action :require_login


  def index
    scores = current_user.karaoke_scores

    @max_scores = scores.group(:song_id).maximum(:score)
    @max_ranking = @max_scores
                   .sort_by { |song_id, score| [ -score, song_id ] }
                   .first(5)

    @average_scores = scores.group(:song_id).average(:score)
    @average_ranking = @average_scores
                       .sort_by { |song_id, score| [ -score, song_id ] }
                       .first(5)

    @song_counts = scores.group(:song_id).count
    @count_ranking = @song_counts
                     .sort_by { |song_id, count| [ -count, song_id ] }
                     .first(5)

    song_ids = (
      @max_ranking.map(&:first) +
      @average_ranking.map(&:first) +
      @count_ranking.map(&:first)
    ).uniq

    @song_titles = Song.where(id: song_ids).pluck(:id, :title).to_h

    @max_dates = {}

    scores.where(song_id: @max_ranking.map(&:first))
          .order(sung_at: :desc, id: :desc)
          .pluck(:song_id, :score, :sung_at)
          .each do |song_id, score, sung_at|
      if score == @max_scores[song_id]
        @max_dates[song_id] ||= sung_at
      end
    end
  end
end
