class Factory_Support
  def initialize
    @totally_initialized = false
  end

  def runtime_initialize(n_players, n_valids)
    @n_players = n_players
    @n_valids = n_valids
    @all_users = User.ids
    @vps = [10]
    @available_users = []
    n_players.times do
      @vps.push(Faker::Number.between(1, 9))
      @available_users.push(@all_users.delete_at(rand(@all_users.length)))
    end
  end

  def assign_user(n_players, n_valids)
    unless @totally_initialized
      runtime_initialize(n_players, n_valids)
    end
    @available_users.delete_at(rand(@available_users.length))
  end

  def assign_vp(n_players, n_valids)
    unless @totally_initialized
      runtime_initialize(n_players, n_valids)
    end
    @vps.delete_at(rand(@vps.length))
  end

  def assign_valid(n_players, n_valids)
    unless @totally_initialized
      runtime_initialize(n_players, n_valids)
    end
    (@n_valids > 0)
  end
end


FactoryGirl.define do
  factory :match, class: Match do
    transient do
      support Factory_Support.new
      n_valids 0
      use_existing_users false
    end
    location { Faker::Address.city }
    add_attribute(:date) { Faker::Date.between(2.days.ago, Date.tomorrow) }
    n_players 4

    trait :existing_users do
      transient do
        use_existing_users true
      end
    end

    trait :of_tournament do
      association :tournament, factory: :tournament, strategy: :create
    end

    after(:create) do |match, evaluator|
      match.n_players.times do
        if evaluator.use_existing_users
          create(:user_match, match: match, vp: evaluator.support.assign_vp(match.n_players, evaluator.n_valids), validated: evaluator.support.assign_valid(match.n_players, evaluator.n_valids), user: evaluator.support.assign_user(match.n_players, evaluator.n_valids))
        else
          create(:user_match, match: match, vp: evaluator.support.assign_vp(match.n_players, evaluator.n_valids), validated: evaluator.support.assign_valid(match.n_players, evaluator.n_valids))
        end
      end
    end
  end
end



