require "rails_helper"

RSpec.describe "karaokescores", type: :request do
    context "ログインしている場合" do
        before do
            user = FactoryBot.create(:user)

            post login_path, params:{
                email: user.email,
                password: "abc"
            }
        end
    it "ログインユーザーが有効な採点結果を送信すると、KaraokeScoreが1件登録されること" do
        expect {
            post karaoke_scores_path, params: {
                karaoke_score: {
                artist_name: "aiko",
                song_title: "milk",
                score: 80,
                sung_at: Date.current
                }
            }
        }.to change(KaraokeScore, :count).by(1)
    end


        it "日付を空で送信した場合、karaokescoreが登録されないこと" do
        expect{
            post karaoke_scores_path, params: {
            karaoke_score: {
                artist_name: "aiko",
                song_title: "milk",
                score: 80,
                sung_at: nil
            }
            }
        }.to change(KaraokeScore, :count).by(0)
    end

    it "有効な採点結果を送信すると、採点結果一覧にリダイレクトされること" do
        post karaoke_scores_path, params: {
            karaoke_score: {
            artist_name: "aiko",
            song_title: "milk",
            score: 80,
            sung_at: Date.current
            }
        }

        expect(response).to redirect_to(karaoke_scores_path)
    end
    end
    
    context "ログインしていない場合" do
    it "未ログインユーザーが採点結果を送信した場合、KaraokeScoreに登録されないこと" do
        expect {
            post karaoke_scores_path, params: {
                karaoke_score: {
                    artist_name: "aiko",
                    song_title: "milk",
                    score: 80,
                    sung_at: Date.current
                }
            }
        }.to change(KaraokeScore, :count).by(0)
    end

    it "未ログインユーザーが採点結果を送信すると、ログイン画面にリダイレクトされること" do
        post karaoke_scores_path, params: {
            karaoke_score: {
                artist_name: "aiko",
                song_title: "milk",
                score: 80,
                sung_at: Date.current
            }
        }

        expect(response).to redirect_to(login_path)
    end
    end
end
