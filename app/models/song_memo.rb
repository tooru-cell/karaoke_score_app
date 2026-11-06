class SongMemo < ApplicationRecord
  belongs_to :user

  validates :song_title, :artist_name, presence: true
end
