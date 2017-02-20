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