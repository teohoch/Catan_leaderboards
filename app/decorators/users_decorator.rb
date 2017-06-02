class UsersDecorator < ApplicationCollectionDecorator

  User::AVAILABLE_RANKINGS.each do |type|
    define_method "#{type}_ranking" do
      ranking type
    end
  end


  private

  def ranking(type,limit:10, page:1)
    if User::AVAILABLE_RANKINGS.include? type
      h.render partial: 'users/rankings', locals: {ranking_type: ('position_'+ type.to_s), users: object.where('matches_played' + ' > (?)',User::NEWBIE_THRESHOLD).order(('elo_'+ type.to_s).to_sym => :desc).limit(limit).offset((page-1)*limit)}
    else
      raise ArgumentError, 'This ranking type is not supported'
    end
  end

end