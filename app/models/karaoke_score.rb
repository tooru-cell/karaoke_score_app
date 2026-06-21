class KaraokeScore < ApplicationRecord
  belongs_to :user
  belongs_to :song

  has_one_attached :score_image

  attr_accessor :artist_name, :song_title

  before_validation :set_song_from_names

  validates :score, presence: true
  validates :sung_at, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      id
      karaoke_machine
      memo
      score
      song_id
      sung_at
      updated_at
      user_id
    ]
  end

  private

  def set_song_from_names
    return if artist_name.blank? && song_title.blank?

    if artist_name.blank?
      errors.add(:artist_name, "を入力してください")
      return
    end

    if song_title.blank?
      errors.add(:song_title, "を入力してください")
      return
    end

    artist = Artist.find_or_create_by!(name: artist_name.strip)

    self.song = Song.find_or_create_by!(
      title: song_title.strip,
      artist: artist
    )
  end
end
