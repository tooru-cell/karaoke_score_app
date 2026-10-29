FactoryBot.define do
  factory :song do
    title { "テスト曲" }
    association :artist
  end
end
