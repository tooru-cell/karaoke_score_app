require "rails_helper"

RSpec.describe "Songs", type: :request do
    describe "GET /songs/:id" do
        before do
            user = FactoryBot.create(:user)

            post login_path, params: {
                email: user.email,
                password: "abc"
            }
        end

        it "採点履歴が０件でも詳細ページを表示できること" do
            song = FactoryBot.create(:song)
            get song_path(song)
            expect(response).to have_http_status(:ok)
        end
    end
end
