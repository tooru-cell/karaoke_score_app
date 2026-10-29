class Song < ApplicationRecord
  belongs_to :artist

  validates :title, presence: true

  has_many :karaoke_scores, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      artist_id
      title
      created_at
      updated_at
    ]
  end
end
