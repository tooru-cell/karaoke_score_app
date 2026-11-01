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

    @chart_data = @scores
                  .reorder(sung_at: :asc, id: :asc)
                  .pluck(:sung_at, :score, :id)

    counts = Hash.new(0)

    @chart_data = @chart_data.map do |sung_at, score, _id|
      counts[sung_at] += 1
      [ "#{sung_at.strftime('%Y/%m/%d')} (#{counts[sung_at]}回目)", score ]
    end

    if @scores.count >= 2
      @difference = @scores.first.score - @scores.second.score
    end
  end
end
