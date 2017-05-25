class TournamentsDecorator < ApplicationCollectionDecorator

  def presentable_attributes
    %w(name prize entrance_fee date status mode rounds current_round registered)
  end

end