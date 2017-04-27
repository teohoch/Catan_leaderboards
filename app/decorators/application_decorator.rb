class ApplicationDecorator < Draper::Decorator
  def pretty_show(table_class = "display table table-condensed table-responsive")
    h.render partial: 'gen'
  end
end