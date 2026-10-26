FactoryBot.define do
  factory :karaoke_score do
    score { 80 }
    sung_at { Date.current }
    association :song
    association :user
  end
end
