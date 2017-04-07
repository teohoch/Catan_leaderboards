require 'rails_helper'
RSpec.describe PyramidGenerator do
  it "should have method generate" do
    expect(PyramidGenerator).to respond_to :generate

  end
  context 'in 4 player mode' do

    before(:all) do
      @board_mode = 4
    end

    context 'with 1 winner' do

      before(:all) do
        @n_winners = 1
      end

      context 'with 2 participants' do
        before(:all) do
          @n_participants = 2
          @users = []
          @n_participants.times do
            @users.push(FactoryGirl.create(:user))
          end
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        it 'should output status False' do
          expect(@result[:status]).to be_falsey
        end

        it 'should output a list of errors' do
          expect(@result[:errors].empty?).to be_falsey
        end

        it 'should output Argument error with minimum participants message' do
          found = false
          @result[:errors].each do |error|
            if error.is_a?(ArgumentError) && error.message == I18n.t('pyramid_generator.minimum_participants')
              found = true
              break
            end
          end
        end

        it 'should output a null object' do
          expect(@result[:object].nil?).to be_truthy
        end
      end

      context 'with 3 participants' do
        before(:all) do
          @n_participants = 3
          @users = FactoryGirl.create_list(:user, @n_participants).map { |user| user.id }
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        subject { @result[:object] }


        ## Common for valid inputs
        it 'should output status True' do
          expect(@result[:status]).to be_truthy
        end

        it 'should output no errors' do
          expect(@result[:errors].empty?).to be_truthy
        end

        it 'should output a object of type hash' do
          expect(subject).to be_a Hash
        end

        it 'should respond to general_configuration' do
          expect(subject).to have_key :general_configuration
        end

        it 'should respond to first_round' do
          expect(subject).to have_key :first_round
        end

        describe 'general configuration' do

          it 'should contain an array' do
            expect(subject[:general_configuration]).to be_a Array
          end

          it 'should be an array of arrays' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round).to be_a Array
            end
          end

          it 'should contain numbers between 3 and the board size' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round.empty?).to be_falsey
              round[2].each do |match|
                expect(match).to be_between(3, @board_mode)
              end
            end
          end

          it 'should have 1 round' do
            expect(subject[:general_configuration].count).to eq(1)
          end

          it 'round 1 should have 1 match' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round[1]).to eq(1)
            end
          end

          it 'the match should have 3 participants' do
            expect(subject[:general_configuration][0][2]).to match_array([3])
          end
        end

        describe 'first_round configuration' do

          it 'should contain an array' do
            expect(subject[:first_round]).to be_a Array
          end

          it 'should be an array of arrays' do
            expect(subject[:first_round].empty?).to be_falsey
            subject[:first_round].each do |match|
              expect(match).to be_a Array
            end
          end

          it 'should have the same number of matches as the first round of general_configuration' do
            expect(subject[:first_round].count).to eq(subject[:general_configuration][0][1])
          end

          it "should have the same number of players in each match as indicated in the general_configuration" do
            round_conf = []
            subject[:first_round].each do |match|
              round_conf.push(match.count)
            end
            expect(round_conf).to match_array(subject[:general_configuration][0][2])
          end

          it 'should contain the ids of the users provided, without repetition' do
            used_ids = subject[:first_round].flatten
            expect(subject[:first_round].empty?).to be_falsey

            @users.each do |user|
              expect(used_ids.count(user)).to eq(1)
            end
          end

        end
      end

      context 'with 4 participants' do
        before(:all) do
          @n_participants = 4
          @users = FactoryGirl.create_list(:user, @n_participants).map { |user| user.id }
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        subject { @result[:object] }


        ## Common for valid inputs
        it 'should output status True' do
          expect(@result[:status]).to be_truthy
        end

        it 'should output no errors' do
          expect(@result[:errors].empty?).to be_truthy
        end

        it 'should output a object of type hash' do
          expect(subject).to be_a Hash
        end

        it 'should respond to general_configuration' do
          expect(subject).to have_key :general_configuration
        end

        it 'should respond to first_round' do
          expect(subject).to have_key :first_round
        end

        describe 'general configuration' do

          it 'should contain an array' do
            expect(subject[:general_configuration]).to be_a Array
          end

          it 'should be an array of arrays' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round).to be_a Array
            end
          end

          it 'should contain numbers between 3 and the board size' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round.empty?).to be_falsey
              round[2].each do |match|
                expect(match).to be_between(3, @board_mode)
              end
            end
          end

          it 'should have 1 round' do
            expect(subject[:general_configuration].count).to eq(1)
          end

          it 'round 1 should have 1 match' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round[1]).to eq(1)
            end
          end

          it 'the match should have 4 participants' do
            expect(subject[:general_configuration][0][2]).to match_array([4])
          end
        end

        describe 'first_round configuration' do

          it 'should contain an array' do
            expect(subject[:first_round]).to be_a Array
          end

          it 'should be an array of arrays' do
            expect(subject[:first_round].empty?).to be_falsey
            subject[:first_round].each do |match|
              expect(match).to be_a Array
            end
          end

          it 'should have the same number of matches as the first round of general_configuration' do
            expect(subject[:first_round].count).to eq(subject[:general_configuration][0][1])
          end

          it "should have the same number of players in each match as indicated in the general_configuration" do
            round_conf = []
            subject[:first_round].each do |match|
              round_conf.push(match.count)
            end
            expect(round_conf).to match_array(subject[:general_configuration][0][2])
          end

          it 'should contain the ids of the users provided, without repetition' do
            used_ids = subject[:first_round].flatten
            expect(subject[:first_round].empty?).to be_falsey

            @users.each do |user|
              expect(used_ids.count(user)).to eq(1)
            end
          end

        end
      end

      context 'with 5 participants' do
        before(:all) do
          @n_participants = 5
          @users = []
          @n_participants.times do
            @users.push(FactoryGirl.create(:user))
          end
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        it 'should output status False' do
          expect(@result[:status]).to be_falsey
        end

        it 'should output a list of errors' do
          expect(@result[:errors].empty?).to be_falsey
        end

        it 'should output Argument error with invalid conbination message' do
          found = false
          @result[:errors].each do |error|
            if error.is_a?(ArgumentError) && error.message == I18n.t('pyramid_generator.invalid_parameter_combination')
              found = true
              break
            end
          end
          expect(found).to be_truthy
        end

        it 'should output a null object' do
          expect(@result[:object]).to be_nil
        end
      end

      context 'with 6 participants' do
        before(:all) do
          @n_participants = 6
          @users = []
          @n_participants.times do
            @users.push(FactoryGirl.create(:user))
          end
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        it 'should output status False' do
          expect(@result[:status]).to be_falsey
        end

        it 'should output a list of errors' do
          expect(@result[:errors].empty?).to be_falsey
        end

        it 'should output Argument error with invalid conbination message' do
          found = false
          @result[:errors].each do |error|
            if error.is_a?(ArgumentError) && error.message == I18n.t('pyramid_generator.invalid_parameter_combination')
              found = true
              break
            end
          end
          expect(found).to be_truthy
        end

        it 'should output a null object' do
          expect(@result[:object]).to be_nil
        end
      end

      context 'with 7 participants' do
        before(:all) do
          @n_participants = 7
          @users = []
          @n_participants.times do
            @users.push(FactoryGirl.create(:user))
          end
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        it 'should output status False' do
          expect(@result[:status]).to be_falsey
        end

        it 'should output a list of errors' do
          expect(@result[:errors].empty?).to be_falsey
        end

        it 'should output Argument error with invalid conbination message' do
          found = false
          @result[:errors].each do |error|
            if error.is_a?(ArgumentError) && error.message == I18n.t('pyramid_generator.invalid_parameter_combination')
              found = true
              break
            end
          end
          expect(found).to be_truthy
        end

        it 'should output a null object' do
          expect(@result[:object]).to be_nil
        end
      end

      context 'with 8 participants' do
        before(:all) do
          @n_participants = 8
          @users = []
          @n_participants.times do
            @users.push(FactoryGirl.create(:user))
          end
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        it 'should output status False' do
          expect(@result[:status]).to be_falsey
        end

        it 'should output a list of errors' do
          expect(@result[:errors].empty?).to be_falsey
        end

        it 'should output Argument error with invalid conbination message' do
          found = false
          @result[:errors].each do |error|
            if error.is_a?(ArgumentError) && error.message == I18n.t('pyramid_generator.invalid_parameter_combination')
              found = true
              break
            end
          end
          expect(found).to be_truthy
        end

        it 'should output a null object' do
          expect(@result[:object]).to be_nil
        end
      end

      context 'with 9 participants' do
        before(:all) do
          @n_participants = 9
          @users = FactoryGirl.create_list(:user, @n_participants).map { |user| user.id }
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        subject { @result[:object] }


        ## Common for valid inputs
        it 'should output status True' do
          expect(@result[:status]).to be_truthy
        end

        it 'should output no errors' do
          expect(@result[:errors].empty?).to be_truthy
        end

        it 'should output a object of type hash' do
          expect(subject).to be_a Hash
        end

        it 'should respond to general_configuration' do
          expect(subject).to have_key :general_configuration
        end

        it 'should respond to first_round' do
          expect(subject).to have_key :first_round
        end

        describe 'general configuration' do

          it 'should contain an array' do
            expect(subject[:general_configuration]).to be_a Array
          end

          it 'should be an array of arrays' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round).to be_a Array
            end
          end

          it 'should contain numbers between 3 and the board size' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round.empty?).to be_falsey
              round[2].each do |match|
                expect(match).to be_between(3, @board_mode)
              end
            end
          end

          it 'should have 2 round' do
            expect(subject[:general_configuration].count).to eq(2)
          end

          context 'round 1' do
            it 'should have 3 matches' do
              expect(subject[:general_configuration].empty?).to be_falsey
              expect(subject[:general_configuration][0][1]).to eq(3)
            end

            it 'should have all matches with 3 players' do
              subject[:general_configuration][0][2].each do |match|
                expect(match).to eq(3)
              end
            end
          end

          context 'round 2' do
            it 'should have 1 matches' do
              expect(subject[:general_configuration].empty?).to be_falsey
              expect(subject[:general_configuration][1][1]).to eq(1)
            end

            it 'should have all matches with 3 players' do
              expect(subject[:general_configuration][1][2]).to match_array([3])
            end
          end
        end

        describe 'first_round configuration' do

          it 'should contain an array' do
            expect(subject[:first_round]).to be_a Array
          end

          it 'should be an array of arrays' do
            expect(subject[:first_round].empty?).to be_falsey
            subject[:first_round].each do |match|
              expect(match).to be_a Array
            end
          end

          it 'should have the same number of matches as the first round of general_configuration' do
            expect(subject[:first_round].count).to eq(subject[:general_configuration][0][1])
          end

          it "should have the same number of players in each match as indicated in the general_configuration" do
            round_conf = []
            subject[:first_round].each do |match|
              round_conf.push(match.count)
            end
            expect(round_conf).to match_array(subject[:general_configuration][0][2])
          end

          it 'should contain the ids of the users provided, without repetition' do
            used_ids = subject[:first_round].flatten
            expect(subject[:first_round].empty?).to be_falsey

            @users.each do |user|
              expect(used_ids.count(user)).to eq(1)
            end
          end

        end
      end

      context 'with 16 participants' do
        before(:all) do
          @n_participants = 16
          @users = FactoryGirl.create_list(:user, @n_participants).map { |user| user.id }
          @result = PyramidGenerator.generate(@board_mode, @n_winners, @users)
        end

        subject { @result[:object] }


        ## Common for valid inputs
        it 'should output status True' do
          expect(@result[:status]).to be_truthy
        end

        it 'should output no errors' do
          expect(@result[:errors].empty?).to be_truthy
        end

        it 'should output a object of type hash' do
          expect(subject).to be_a Hash
        end

        it 'should respond to general_configuration' do
          expect(subject).to have_key :general_configuration
        end

        it 'should respond to first_round' do
          expect(subject).to have_key :first_round
        end

        describe 'general configuration' do

          it 'should contain an array' do
            expect(subject[:general_configuration]).to be_a Array
          end

          it 'should be an array of arrays' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round).to be_a Array
            end
          end

          it 'should contain numbers between 3 and the board size' do
            expect(subject[:general_configuration].empty?).to be_falsey
            subject[:general_configuration].each do |round|
              expect(round.empty?).to be_falsey
              round[2].each do |match|
                expect(match).to be_between(3, @board_mode)
              end
            end
          end

          it 'should have 2 round' do
            expect(subject[:general_configuration].count).to eq(2)
          end

          context 'round 1' do
            it 'should have 4 matches' do
              expect(subject[:general_configuration].empty?).to be_falsey
              expect(subject[:general_configuration][0][1]).to eq(4)
            end

            it 'should have all matches with 4 players' do
              expect(subject[:general_configuration][0][2]).to match_array([4, 4, 4, 4])
            end
          end

          context 'round 2' do
            it 'should have 1 matches' do
              expect(subject[:general_configuration].empty?).to be_falsey
              expect(subject[:general_configuration][1][1]).to eq(1)
            end

            it 'should have all matches with 4 players' do
              expect(subject[:general_configuration].empty?).to be_falsey
              expect(subject[:general_configuration][1][2]).to match_array([4])
            end
          end
        end

        describe 'first_round configuration' do

          it 'should contain an array' do
            expect(subject[:first_round]).to be_a Array
          end

          it 'should be an array of arrays' do
            expect(subject[:first_round].empty?).to be_falsey
            subject[:first_round].each do |match|
              expect(match).to be_a Array
            end
          end

          it 'should have the same number of matches as the first round of general_configuration' do
            expect(subject[:first_round].count).to eq(subject[:general_configuration][0][1])
          end

          it "should have the same number of players in each match as indicated in the general_configuration" do
            round_conf = []
            subject[:first_round].each do |match|
              round_conf.push(match.count)
            end
            expect(round_conf).to match_array(subject[:general_configuration][0][2])
          end

          it 'should contain the ids of the users provided, without repetition' do
            used_ids = subject[:first_round].flatten
            expect(subject[:first_round].empty?).to be_falsey

            @users.each do |user|
              expect(used_ids.count(user)).to eq(1)
            end
          end

        end
      end

    end
  end
end



