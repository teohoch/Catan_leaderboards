FactoryGirl.define do
  factory :user, class: User do
    name {Faker::Name.name}
    email { Faker::Internet.email(name) }
    password 'password'
    password_confirmation 'password'

    trait :random_elo do
      transient do
        elo_range (5..45)
      end
      elo_general {rand(elo_range) * 100}
      elo_free {rand(elo_range) * 100}
      elo_tournament {rand(elo_range) * 100}
    end

    trait :with_matches do
      transient do
        n_matches_range (1..5)
      end
      matches_played {rand(n_matches_range)}

    end

  end
end