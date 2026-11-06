require 'rails_helper'

RSpec.describe "Rankings", type: :request do
  describe "GET /rankings" do
    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }
      let(:user_b) { FactoryBot.create(:user) }

      before do
        post login_path, params: {
          email: user.email,
          password: "abc"
        }
      end
      it "最高点と平均点が正しく表示されていること" do
        song_a = FactoryBot.create(:song)

        FactoryBot.create(:karaoke_score, user: user, song: song_a, score: 80)
        FactoryBot.create(:karaoke_score, user: user, song: song_a, score: 90)

        get rankings_path

        expect(response.body).to include("90.0")
        expect(response.body).to include("85.0")
        expect(response.body).to include(song_a.title)
      end


      it "最高点が同じ曲は同順位になり、次の曲は２位になる" do
        song_a = FactoryBot.create(:song)
        song_b = FactoryBot.create(:song)
        song_c = FactoryBot.create(:song)

        FactoryBot.create(:karaoke_score, user: user, song: song_a, score: 95)
        FactoryBot.create(:karaoke_score, user: user, song: song_b, score: 95)
        FactoryBot.create(:karaoke_score, user: user, song: song_c, score: 90)

        get rankings_path
        page = Capybara.string(response.body)

        [
          [ song_a, "1位", "95.0点" ],
          [ song_b, "1位", "95.0点" ],
          [ song_c, "2位", "90.0点" ]
        ].each do |song, rank, score|
          expect(page).to have_css(
            "section:nth-of-type(1) div.flex.items-center.gap-3.py-4",
            text: /#{rank}\s*#{Regexp.escape(song.title)}.*#{Regexp.escape(score)}/m
          )
        end
      end


      it "別のユーザーの採点結果が表示されないこと" do
        song_a = FactoryBot.create(:song, title: "曲A")
        song_b = FactoryBot.create(:song, title: "曲B")
        FactoryBot.create(:karaoke_score, user: user, song: song_a, score: 90)
        FactoryBot.create(:karaoke_score, user: user_b, song: song_b, score: 80)
        get rankings_path
        expect(response.body).to include(song_a.title)
        expect(response.body).not_to include(song_b.title)
      end

    it "歌唱回数が正しく表示されること" do
      song_a = FactoryBot.create(:song, title: "曲A")
      song_b = FactoryBot.create(:song, title: "曲B")
      song_c = FactoryBot.create(:song, title: "曲C")

      FactoryBot.create_list(:karaoke_score, 3, user: user, song: song_a)
      FactoryBot.create_list(:karaoke_score, 3, user: user, song: song_b)
      FactoryBot.create_list(:karaoke_score, 1, user: user, song: song_c)

      get rankings_path
      page = Capybara.string(response.body)

      [
        [ song_a, "1位", "3回" ],
        [ song_b, "1位", "3回" ],
        [ song_c, "2位", "1回" ]
      ].each do |song, rank, count|
        expect(page).to have_css(
          "section:nth-of-type(3) div.flex.items-center.gap-3.py-4",
          text: /#{rank}\s*#{Regexp.escape(song.title)}\s*#{Regexp.escape(count)}/
        )
      end
    end

      it "ログインしているユーザーはランキング画面を表示することができる" do
        get rankings_path
        expect(response).to have_http_status(:success)
      end

      it "採点履歴がなくてもランキング画面を表示できる" do
        get rankings_path
        expect(response).to have_http_status(:success)
        expect(user.karaoke_scores.count).to eq(0)
      end
    end
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトされる" do
        get rankings_path
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
