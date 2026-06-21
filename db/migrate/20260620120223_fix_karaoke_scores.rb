class FixKaraokeScores < ActiveRecord::Migration[7.2]
  def change
    remove_column :karaoke_scores, :name, :string

    add_reference :karaoke_scores, :user, foreign_key: true
    add_reference :karaoke_scores, :song, foreign_key: true

    add_column :karaoke_scores, :score, :decimal, precision: 5, scale: 2
    add_column :karaoke_scores, :karaoke_machine, :integer
    add_column :karaoke_scores, :sung_at, :date
    add_column :karaoke_scores, :memo, :text
  end
end
