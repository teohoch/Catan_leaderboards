# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

fuser = User.new(:email => "teohoch2@gmail.com",
                 :name => "Teodoro Hochfärber",
                 :password => 'password',
                 :password_confirmation => 'password')

fuser.save

fuser2 = User.new(:email => "teodoro.hochfarber@gmail.com",
                 :name => "Teo2",
                 :password => 'password',
                 :password_confirmation => 'password')

fuser2.save

fuser3 = User.new(:email => "testing@test.com",
                  :name => "testin1",
                  :password => 'password',
                  :password_confirmation => 'password')

fuser3.save

fuser4 = User.new(:email => "testing2@test.com",
                  :name => "testin2",
                  :password => 'password',
                  :password_confirmation => 'password')

fuser4.save

tournament1 = Tournament.new(
    :name => "Torneo1",
    :user_id => fuser.id,
    :number_players => 8,
    :prize => "Something Shiny",
    :entrance_fee => 10500,
    :date => Date.tomorrow,
    :rounds => 2,
    :mode => 0)

tournament1.save

tournament2 = Tournament.new(
    :name => "Torneo2",
    :user_id => fuser.id,
    :number_players => 8,
    :prize => "Something opaque",
    :entrance_fee => 10500,
    :date => Date.tomorrow,
    :rounds => 0,
    :mode => 2)

tournament2.save

5.times do
  Match.new_with_child(:date => Faker::Date.between(Date.today, 1.month.from_now),
                       :location => Faker::Address.city,
                       :user_matches_attributes => {
                           0 => {
                               :user_id => "4",
                               :validated => "true",
                               :vp => Faker::Number.between(1, 10)},
                           1487648543682 => {
                               :user_id => "2",
                               :_destroy => "false",
                               :vp => Faker::Number.between(1, 10)},
                           1487648544163 => {
                               :user_id => "3",
                               :_destroy => "false",
                               :vp => Faker::Number.between(1, 10)},
                           1487648544636 => {
                               :user_id => "1",
                               :_destroy => "false",
                               :vp => Faker::Number.between(1, 10)}
                       })
end


