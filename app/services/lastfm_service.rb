require "net/http"
require "json"

class LastfmService
  BASE_URL = "https://ws.audioscrobbler.com/2.0/".freeze

  def self.top_tracks(artist_name)
    api_key = Rails.application.credentials.dig(:lastfm, :api_key)

    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form(
      method: "artist.gettoptracks",
      artist: artist_name,
      api_key: api_key,
      format: "json",
      limit: 10
    )

    response = Net::HTTP.get_response(uri)
    return [] unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    return [] if data["error"]

    Array(data.dig("toptracks", "track")).map do |track|
      {
        title: track["name"],
        artist_name: track.dig("artist", "name")
      }
    end
  rescue StandardError => e
    Rails.logger.error("Last.fm API error: #{e.class}")
    []
  end
end
