class SongsController < ApplicationController
  before_action :require_login

  def show
    @song = Song.find(params[:id])

    @scores = current_user.karaoke_scores
                          .where(song: @song)
                          .order(sung_at: :desc)

    @recent_scores = @scores
                 .reorder(sung_at: :desc, id: :desc)
                 .limit(3)

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

    @machine_scores = @scores
                      .reorder(sung_at: :asc, id: :asc)
                      .pluck(:sung_at, :score, :id, :karaoke_machine)

    counts = Hash.new(0)

    labels = []
    dam_data = []
    joy_data = []

    @machine_scores.each do |sung_at, score, _id, karaoke_machine|
      counts[sung_at] += 1
      label = "#{sung_at.strftime('%Y/%m/%d')} (#{counts[sung_at]}回目)"

      labels << label

      if karaoke_machine == "dam"
        dam_data << score
        joy_data << nil
      elsif karaoke_machine == "joysound"
        joy_data << score
        dam_data << nil
      else
        dam_data << nil
        joy_data << nil
      end
    end

    if @scores.count >= 2
      @difference = @scores.first.score - @scores.second.score
    end

    @machine_chart_data = [
      { name: "DAM", data: labels.zip(dam_data) },
      { name: "JOYSOUND", data: labels.zip(joy_data) }
    ]
  end


  def history
    @song = Song.find(params[:id])

    @q = current_user.karaoke_scores
                     .where(song: @song)
                     .ransack(params[:q])

    @q.sorts = "sung_at desc" if @q.sorts.empty?

    @scores = @q.result.order(id: :desc)
  end
end
