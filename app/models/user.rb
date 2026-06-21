class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password_confirmation

  has_many :karaoke_scores, dependent: :destroy

  validates :name, presence: true

  validates :email,
            presence: true,
            uniqueness: true

  validates :password,
            length: { minimum: 3 },
            if: -> { new_record? || changes[:crypted_password] }

  validates :password_confirmation,
            presence: true,
            if: -> { new_record? || changes[:crypted_password] }
end
