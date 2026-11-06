class SongMemosController < ApplicationController
  before_action :require_login
  
  def index
    @song_memos = current_user.song_memos.order(created_at: :desc)
    @song_memo = current_user.song_memos.build

    artist_counts = current_user.karaoke_scores
                                .joins(song: :artist)
                                .group("artists.id")
                                .count

    favorite_artist_id = artist_counts.max_by { |id, count| count }&.first

    @favorite_artist = Artist.find_by(id: favorite_artist_id)
    
    @recommended_tracks = []

    if @favorite_artist
      tracks = LastfmService.top_tracks(@favorite_artist.name)

      sung_titles = current_user.karaoke_scores
                                .joins(:song)
                                .where(songs: { artist_id: @favorite_artist.id })
                                .pluck("songs.title")

      
    memo_titles = current_user.song_memos
                              .where(artist_name: @favorite_artist.name)
                              .pluck(:song_title)

    excluded_titles = (sung_titles + memo_titles).map(&:downcase)

    @recommended_tracks = tracks.reject do |track|
      excluded_titles.include?(track[:title].downcase)
    end.first(5)

    end

  end


  def create
    @song_memo = current_user.song_memos.build(song_memo_params)

    if @song_memo.save
      redirect_to song_memos_path
    else
      @song_memos = current_user.song_memos.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @song_memo = current_user.song_memos.find(params[:id])
    @song_memo.destroy
    redirect_to song_memos_path
  end

  private

  def song_memo_params
    params.require(:song_memo).permit(:song_title, :artist_name)
  end
end
