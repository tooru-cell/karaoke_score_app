class ChangeScoreScaleInKaraokeScores < ActiveRecord::Migration[7.2]
  def change
    change_column :karaoke_scores, :score, :decimal, precision: 6, scale: 3
  end
end
