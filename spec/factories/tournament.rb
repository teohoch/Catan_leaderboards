FactoryGirl.define do
  factory :tournament, class: Tournament do
    name "Annual Tournament"
    number_players 4
    prize { Faker::StarWars.vehicle }
    entrance_fee { Faker::Number.number(4) }
    date { Date.today }
    association :user, factory: :user, strategy: :create
    rounds 0
  end
end