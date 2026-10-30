class Artist < ApplicationRecord
  has_many :songs, dependent: :destroy

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      name
    ]
  end
end
