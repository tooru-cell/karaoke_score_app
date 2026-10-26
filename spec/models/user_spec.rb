require 'rails_helper'

RSpec.describe User, type: :model do
  it "名前が空の場合、Userが無効になること" do
    user = FactoryBot.build(:user, name: nil)
    expect(user.valid?).to eq(false)
  end

  it "Eメールが空の場合、Userが無効になること" do
    user = FactoryBot.build(:user, email: nil)
    expect(user.valid?).to eq(false)
  end

  it "同じemailが既に登録されている場合、Userが無効になること" do
    user1 = FactoryBot.create(:user, email: "test@example.com")
    user2 = FactoryBot.build(:user, email: "test@example.com")
    expect(user2.valid?).to eq(false)
  end

  it "パスワードが2文字の場合、Userが無効になること" do
    user = FactoryBot.build(:user, password: "ab", password_confirmation: "ab")
    expect(user.valid?).to eq(false)
  end

  it "パスワードが3文字の場合、Userが有効になること" do
    user = FactoryBot.build(:user, password: "abc", password_confirmation: "abc")
    expect(user.valid?).to eq(true)
  end

  it "パスワードと確認用パスワードが一致しない場合、Userが無効になること" do
    user = FactoryBot.build(:user, password: "abc", password_confirmation: "xyz")
    expect(user.valid?).to eq(false)
  end

  it "確認用パスワードが空の場合、Userが無効になること" do
    user = FactoryBot.build(:user, password: "abc", password_confirmation: nil)
    expect(user.valid?).to eq(false)
  end

  it "有効な属性の場合、Userが有効になること" do
    user = FactoryBot.build(:user)
    expect(user.valid?).to eq(true)
  end
end
