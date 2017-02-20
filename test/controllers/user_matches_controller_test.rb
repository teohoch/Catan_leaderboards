require 'test_helper'

class UserMatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_match = user_matches(:one)
  end

  test "should get index" do
    get user_matches_url
    assert_response :success
  end

  test "should get new" do
    get new_user_match_url
    assert_response :success
  end

  test "should create user_match" do
    assert_difference('UserMatch.count') do
      post user_matches_url, params: {user_match: {elo_free: @user_match.elo_free, elo_free_change: @user_match.elo_free_change, elo_general: @user_match.elo_general, elo_general_change: @user_match.elo_general_change, elo_tournament: @user_match.elo_tournament, elo_tournament_change: @user_match.elo_tournament_change, match_id: @user_match.match_id, tournament_point: @user_match.tournament_point, user_id: @user_match.user_id, victory_position: @user_match.victory_position, vp: @user_match.vp}}
    end

    assert_redirected_to user_match_url(UserMatch.last)
  end

  test "should show user_match" do
    get user_match_url(@user_match)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_match_url(@user_match)
    assert_response :success
  end

  test "should update user_match" do
    patch user_match_url(@user_match), params: {user_match: {elo_free: @user_match.elo_free, elo_free_change: @user_match.elo_free_change, elo_general: @user_match.elo_general, elo_general_change: @user_match.elo_general_change, elo_tournament: @user_match.elo_tournament, elo_tournament_change: @user_match.elo_tournament_change, match_id: @user_match.match_id, tournament_point: @user_match.tournament_point, user_id: @user_match.user_id, victory_position: @user_match.victory_position, vp: @user_match.vp}}
    assert_redirected_to user_match_url(@user_match)
  end

  test "should destroy user_match" do
    assert_difference('UserMatch.count', -1) do
      delete user_match_url(@user_match)
    end

    assert_redirected_to user_matches_url
  end
end
