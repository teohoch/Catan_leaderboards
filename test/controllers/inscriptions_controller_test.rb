require 'test_helper'

class InscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inscription = inscriptions(:one)
  end

  test "should get index" do
    get inscriptions_url
    assert_response :success
  end

  test "should get new" do
    get new_inscription_url
    assert_response :success
  end

  test "should create inscription" do
    assert_difference('Inscription.count') do
      post inscriptions_url, params: { inscription: { create: @inscription.create, delete: @inscription.delete, show: @inscription.show, update: @inscription.update } }
    end

    assert_redirected_to inscription_url(Inscription.last)
  end

  test "should show inscription" do
    get inscription_url(@inscription)
    assert_response :success
  end

  test "should get edit" do
    get edit_inscription_url(@inscription)
    assert_response :success
  end

  test "should update inscription" do
    patch inscription_url(@inscription), params: { inscription: { create: @inscription.create, delete: @inscription.delete, show: @inscription.show, update: @inscription.update } }
    assert_redirected_to inscription_url(@inscription)
  end

  test "should destroy inscription" do
    assert_difference('Inscription.count', -1) do
      delete inscription_url(@inscription)
    end

    assert_redirected_to inscriptions_url
  end
end
