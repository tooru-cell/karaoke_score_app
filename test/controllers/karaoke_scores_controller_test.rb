require "test_helper"

class KaraokeScoresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get karaoke_scores_index_url
    assert_response :success
  end

  test "should get new" do
    get karaoke_scores_new_url
    assert_response :success
  end

  test "should get create" do
    get karaoke_scores_create_url
    assert_response :success
  end

  test "should get show" do
    get karaoke_scores_show_url
    assert_response :success
  end

  test "should get edit" do
    get karaoke_scores_edit_url
    assert_response :success
  end

  test "should get update" do
    get karaoke_scores_update_url
    assert_response :success
  end

  test "should get destroy" do
    get karaoke_scores_destroy_url
    assert_response :success
  end
end
