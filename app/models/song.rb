class Song < ApplicationRecord
  belongs_to :artist

  validates :title, presence: true

  has_many :karaoke_scores, dependent: :destroy
end
