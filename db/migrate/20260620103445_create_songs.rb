class CreateSongs < ActiveRecord::Migration[7.2]
  def change
    create_table :songs do |t|
      t.references :artist, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
