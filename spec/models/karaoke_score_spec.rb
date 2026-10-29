require 'rails_helper'

RSpec.describe KaraokeScore, type: :model do
  it "点数が-1点なら無効であること" do
    karaoke_score = FactoryBot.build(:karaoke_score, score: -1)
    expect(karaoke_score.valid?).to eq(false)
  end

  it "点数が0点なら有効であること" do
    karaoke_score = FactoryBot.build(:karaoke_score, score: 0)
    karaoke_score.valid?
    puts karaoke_score.errors.full_messages
    expect(karaoke_score.valid?).to eq(true)
  end

  it "点数が100点なら有効であること" do
    karaoke_score = FactoryBot.build(:karaoke_score, score: 100)
    expect(karaoke_score.valid?).to eq(true)
  end

  it "点数が101点なら無効であること" do
    karaoke_score = FactoryBot.build(:karaoke_score, score: 101)
    expect(karaoke_score.valid?).to eq(false)
  end

  it "点数が空なら無効であること" do
    karaoke_score = FactoryBot.build(:karaoke_score, score: nil)
    expect(karaoke_score.valid?).to eq(false)
  end

  it "歌唱日が空なら無効であること" do
    karaoke_score = FactoryBot.build(:karaoke_score, sung_at: nil)
    expect(karaoke_score.valid?).to eq(false)
  end

  it "歌唱日が未来なら無効であること" do
    karaoke_score = FactoryBot.build(:karaoke_score, sung_at: Date.current + 1.day)
    expect(karaoke_score.valid?).to eq(false)
  end

  it "歌唱日が今日なら有効であること" do
    karaoke_score = FactoryBot.build(:karaoke_score, sung_at: Date.current)
    expect(karaoke_score.valid?).to eq(true)
  end

  it "曲名が設定されること" do
    karaoke_score = FactoryBot.build(
      :karaoke_score,
      artist_name: "aiko",
      song_title: "milk"
    )

    karaoke_score.valid?

    expect(karaoke_score.song.title).to eq("milk")
    expect(karaoke_score.song.artist.name).to eq("aiko")
  end

  it "同一名の歌手が登録されているとき、既存の歌手が再利用されること" do
    artist = FactoryBot.create(:artist, name: "aiko")

    karaoke_score = FactoryBot.build(
      :karaoke_score,
      artist_name: "aiko",
      song_title: "milk"
    )

    karaoke_score.valid?

    expect(karaoke_score.song.artist.id).to eq(artist.id)
  end

  it "歌手名が空の場合、エラーメッセージが追加されること" do
    karaoke_score = FactoryBot.build(
      :karaoke_score,
      artist_name: nil,
      song_title: "milk"
    )

    expect(karaoke_score.valid?).to eq(false)
    expect(karaoke_score.errors[:artist_name]).to include("を入力してください")
  end

  it "曲名が空の場合、エラーメッセージが追加されること" do
    karaoke_score = FactoryBot.build(
      :karaoke_score,
      artist_name: "aiko",
      song_title: nil
    )

    expect(karaoke_score.valid?).to eq(false)
    expect(karaoke_score.errors[:song_title]).to include("を入力してください")
  end
end
