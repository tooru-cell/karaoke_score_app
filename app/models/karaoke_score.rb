class KaraokeScore < ApplicationRecord
  belongs_to :user
  belongs_to :song

  has_one_attached :score_image

  attr_accessor :artist_name, :song_title

  before_validation :set_song_from_names

  validate :sung_at_cannot_be_in_the_future

  validates :score, presence: true,
                  numericality: {
                    greater_than_or_equal_to: 0,
                    less_than_or_equal_to: 100
                  }
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

  def self.ransackable_associations(auth_object = nil)
    %w[song user]
  end

  private

  def sung_at_cannot_be_in_the_future
    return if sung_at.blank?

    if sung_at > Date.current
        errors.add(:sung_at, "に未来の日付は選択できません")
    end
  end

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
