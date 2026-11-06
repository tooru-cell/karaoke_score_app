require 'rails_helper'

RSpec.describe "SongMemos", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/song_memos/index"
      expect(response).to have_http_status(:success)
    end
  end

end
