class MatchesDecorator< ApplicationCollectionDecorator
  def presentable_attributes
    %w(date location n_players validated)
  end
  def show_user_matches
    if h.current_user
      output = h.content_tag(:h2,[Match.model_name.human(count: 2), (h.t 'of'), h.current_user.name].join(' '))
      output + self.object.user(h.current_user).dup.decorate.show_all
    end
  end

end