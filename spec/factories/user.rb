FactoryGirl.define do
  factory :user, class: User do
    sequence(:email){|n| "person#{n}@mail.com"}
    password "password"
    password_confirmation "password"
    name {Faker::Name.name}
  end
end