class CreateSongMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :song_memos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :song_title, null: false
      t.string :artist_name, null: false

      t.timestamps
    end
  end
end
