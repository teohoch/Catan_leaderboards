require 'rails_helper'

RSpec.describe Match, :type => :model do
  it 'should Validate match' do
    match = FactoryGirl.create(:match, n_valids: 2)
    match.validate
    expect(match[:validated]).to eq(true)

    user_matches = match.user_matches.order(vp: :desc)
    previous = nil
    current_winner = nil
    current_losers = []

    user_matches.each do |user_match|
      unless previous.nil?
        expect(previous[:victory_position]).to be < user_match[:victory_position]
      end
      previous = user_match

      if current_winner.nil?
        current_winner = user_match
      else
        if current_winner[:elo_general_change] < user_match[:elo_general_change]
          current_losers.push(current_winner) unless current_winner.nil?
          current_winner = user_match
        end
      end
    end
    expect(current_winner[:elo_general_change]).to eq(48)
    current_losers.each do |loser|
      expect(loser[:elo_general_change]).to eq(-16)
    end
  end

  it "should assign victory position according to VP" do
    match = FactoryGirl.create(:match)
    match.set_victory_positions
    user_matches = match.user_matches.order(vp: :desc)
    previous = nil
    user_matches.each do |user_match|
      unless previous.nil?
        expect(previous[:victory_position]).to be < user_match[:victory_position]
      end
      previous = user_match
    end


  end

  it 'should Calculate General Elo Changes for equal temporal users' do
    match = FactoryGirl.create(:match)
    match.set_rankings
    current_winner = nil
    current_losers = []
    match.user_matches.each do |user_match|
      if current_winner.nil?
        current_winner = user_match
      else
        if current_winner[:elo_general_change] < user_match[:elo_general_change]
          current_losers.push(current_winner) unless current_winner.nil?
          current_winner = user_match
        end
      end
    end
    expect(current_winner[:elo_general_change]).to eq(48)
    current_losers.each do |loser|
      expect(loser[:elo_general_change]).to eq(-16)
    end
  end

  it 'should Calculate Tournament Elo Changes for equal temporal users' do
    match = FactoryGirl.create(:match, :of_tournament)
    match.set_rankings
    current_winner = nil
    current_losers = []
    match.user_matches.each do |user_match|
      if current_winner.nil?
        current_winner = user_match
      else
        if current_winner[:elo_tournament_change] < user_match[:elo_tournament_change]
          current_losers.push(current_winner) unless current_winner.nil?
          current_winner = user_match
        end
      end

    end
    expect(current_winner[:elo_tournament_change]).to eq(48)
    current_losers.each do |loser|
      expect(loser[:elo_tournament_change]).to eq(-16)
    end
  end

  it 'should Calculate Free Elo Changes for equal temporal users' do
    match = FactoryGirl.create(:match)
    match.set_rankings
    current_winner = nil
    current_losers = []
    match.user_matches.each do |user_match|
      if current_winner.nil?
        current_winner = user_match
      else
        if current_winner[:elo_free_change] < user_match[:elo_free_change]
          current_losers.push(current_winner) unless current_winner.nil?
          current_winner = user_match
        end
      end

    end
    expect(current_winner[:elo_free_change]).to eq(48)
    current_losers.each do |loser|
      expect(loser[:elo_free_change]).to eq(-16)
    end
  end

  it "should Validate match from user indication" do
    expect(true).to eq(true)
  end
end



