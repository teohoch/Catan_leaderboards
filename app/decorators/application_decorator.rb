class ApplicationDecorator < Draper::Decorator
  def attributes
    model.attributes
  end

  def pretty_show(table_class: "display table table-condensed table-responsive", title: '')
    h.render partial: 'general_show', locals: {object: self.attributes, title: title,  table_class: table_class, klass: model.class}
  end

end

class ApplicationCollectionDecorator < Draper::CollectionDecorator
  def show_all
    h.render partial: 'index_table', locals: {collection: self.object, attributes: presentable_attributes, klass: object.model}
  end

  def presentable_attributes
    []
  end
end