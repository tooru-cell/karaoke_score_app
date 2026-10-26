FactoryBot.define do
  factory :user do
    name { "neko" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "abc" }
    password_confirmation { "abc" }
  end
end
