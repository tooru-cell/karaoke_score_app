require "rails_helper"

RSpec.describe "Songs", type: :request do
    describe "GET /songs/:id" do
        before do
            @user = FactoryBot.create(:user)

            post login_path, params: {
                email: @user.email,
                password: "abc"
            }
        end

        it "採点履歴が０件でも詳細ページを表示できること" do
            song = FactoryBot.create(:song)
            get song_path(song)
            expect(response).to have_http_status(:ok)
        end

        it "DAMとJOYSOUNDの採点結果が機種別グラフに含まれること" do
            song = FactoryBot.create(:song)

            FactoryBot.create(
                :karaoke_score,
                user: @user,
                song: song,
                score: 80,
                karaoke_machine: :dam
            )
            FactoryBot.create(
                :karaoke_score,
                user: @user,
                song: song,
                score: 90,
                karaoke_machine: :joysound
            )
            get song_path(song)

            expect(response).to have_http_status(:ok)
            expect(response.body).to match(/"name":"DAM","data":\[\["[^"]+","80\.0"\]/)
            expect(response.body).to match(/"name":"JOYSOUND".*90\.0/)
        end

        it "同じ日に複数回歌った採点結果がすべてグラフに含まれること" do
            song = FactoryBot.create(:song)

            FactoryBot.create(
                :karaoke_score,
                user: @user,
                song: song,
                score: 80,
                sung_at: Date.current,
                karaoke_machine: :dam
            )
            FactoryBot.create(
                :karaoke_score,
                user: @user,
                song: song,
                score: 85,
                sung_at: Date.current,
                karaoke_machine: :dam
            )
            FactoryBot.create(
                :karaoke_score,
                user: @user,
                song: song,
                score: 90,
                sung_at: Date.current,
                karaoke_machine: :joysound
            )
            get song_path(song)
            expect(response).to have_http_status(:ok)
            chart_html = response.body.lines.find do |line|
                line.include?('new Chartkick["LineChart"]("chart-2"')
            end
            expect(chart_html).to match(/"name":"DAM","data":\[\["[^"]+","80\.0"\],\["[^"]+","85\.0"\]/)

            expect(chart_html).to match(/"name":"JOYSOUND","data":\[\["[^"]+",null\],\["[^"]+",null\],\["[^"]+","90\.0"\]/)
        end
    end
end
