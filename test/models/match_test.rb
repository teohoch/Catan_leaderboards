require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "correct_validation" do
    user1 = users(:teo1)
    user2 = users(:teo2)
    user3 = users(:teo3)
    user4 = users(:teo4)


    select = Match.new_with_child(:date => Faker::Date.between(Date.today, 1.month.from_now),
                         :location => Faker::Address.city,
                         :user_matches_attributes => {
                             0 => {
                                 :user_id => user1.id,
                                 :validated => "true",
                                 :vp => Faker::Number.between(1, 10)},
                             1487648543682 => {
                                 :user_id => user2.id,
                                 :_destroy => "true",
                                 :vp => Faker::Number.between(1, 10)},
                             1487648544163 => {
                                 :user_id => user3.id,
                                 :_destroy => "false",
                                 :vp => Faker::Number.between(1, 10)},
                             1487648544636 => {
                                 :user_id => user4.id,
                                 :_destroy => "false",
                                 :vp => Faker::Number.between(1, 10)}
                         })
    select[:object].validate_match
    assert select[:object].validated == true


  end
end
