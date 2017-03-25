class PyramidGenerator
  def self.generate(board_mode, n_winners, users)
    participants = users.count
    status = true
    errors = []
    object = nil

    inf = 1.0/0

    case board_mode
      when 4
        case participants
          when -inf..2
            status = false
            errors.push(ArgumentError.new(I18n.t('pyramid_generator.minimum_participants')))
          when 3..4
            object = {}
            object[:general_configuration] = [[participants]]
            object[:first_round] = [users]
          when 5
            status = false
            errors.push(ArgumentError.new(I18n.t('pyramid_generator.invalid_parameter_combination')))
          when 6..8
            if n_winners == 2
            else
              status = false
              errors.push(ArgumentError.new(I18n.t('pyramid_generator.invalid_parameter_combination')))
            end
          when 9..inf
            if n_winners == 1

            elsif n_winners == 2
            else
              status = false
              errors.push(ArgumentError.new(I18n.t('pyramid_generator.invalid_parameter_combination')))
            end
          else
            status = false
            errors.push(ArgumentError.new(I18n.t('pyramid_generator.invalid_parameter_combination')))
        end
      when 6
        not_implemented
      else
        status = false
        errors.push(ArgumentError.new(t('pyramid_generator.board_size_error')))
    end

    {:status => status, :errors => errors, :object => object}
  end

  def self.validator(board_mode, n_winners, users, round=0)
    inf = 1.0/0
    output = {:status => nil, :rounds => []}
    minimum_participants =[n_winners+1, 3].max
    case users
      when -inf..2
        output[:status] = -2
      when 3..board_mode
        output[:status] = 0
        output[:rounds].push([round, [users]])
      else

        flag = false
        board_mode.downto(minimum_participants).to_a.each do |participants|
          n_matches = (users.to_f / participants)
          n_matches = (users <= (n_matches.to_i*board_mode) ? n_matches.floor : n_matches.ceil).to_i

          if n_matches * n_winners < users && n_matches * participants <= users && n_matches * n_winners >= minimum_participants
            next_recursion = self.validator(board_mode, n_winners, n_matches * n_winners, round+1)

            if next_recursion[:status] == 0
              current_round = []
              if (participants * n_matches) == users
                n_matches.times do
                  current_round.push(participants)
                end
              else
                plus_matches = users -(participants * n_matches)
                plus_matches.times do
                  current_round.push(participants+1)
                end
                (n_matches - plus_matches).times do
                  current_round.push(participants)
                end
              end


              output[:status] = 0
              output[:rounds].concat(next_recursion[:rounds])
              output[:rounds].push([round, current_round])
              flag = true
              break

            end
          end
        end
        unless flag
          output[:status]=-1
          output[:rounds]= []
        end
    end
    output
  end
end

puts (15).to_s + PyramidGenerator.validator(4, 1, 15).to_s

puts 'Tablero de 4 - Pasa 1'

30.times do |index|
  puts (index+1).to_s + PyramidGenerator.validator(4, 1, index+1).to_s
end

puts " "
puts 'Tablero de 4 - Pasa 2'
20.times do |index|
  puts (index+1).to_s + PyramidGenerator.validator(4, 2, index+1).to_s
end


puts " "
puts 'Tablero de 4 - Pasa 3'
20.times do |index|
  puts (index+1).to_s + PyramidGenerator.validator(4, 3, index+1).to_s
end


puts " "
puts 'Tablero de 6 - Pasa 1'

30.times do |index|
  puts (index+1).to_s + PyramidGenerator.validator(6, 1, index+1).to_s
end

puts " "
puts 'Tablero de 6 - Pasa 2'
20.times do |index|
  puts (index+1).to_s + PyramidGenerator.validator(6, 2, index+1).to_s
end


puts " "
puts 'Tablero de 6 - Pasa 3'
20.times do |index|
  puts (index+1).to_s + PyramidGenerator.validator(6, 3, index+1).to_s
end

puts " "
puts 'Tablero de 6 - Pasa 4'
20.times do |index|
  puts (index+1).to_s + PyramidGenerator.validator(6, 4, index+1).to_s
end
