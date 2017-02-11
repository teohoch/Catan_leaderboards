module ApplicationHelper

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

  def render_flash
    rendered = []
    flash.each do |type, messages|
      if messages.is_a? Array
        messages.each do |m|
          rendered << render(:partial => 'layouts/flash_message', :locals => {:type => type, :message => m}) unless m.blank?
        end
      else
        rendered << render(:partial => 'layouts/flash_message', :locals => {:type => type, :message => messages}) unless messages.blank?
      end
    end
    html = rendered.join.squish
    return html.html_safe
  end

  def bootstrap_class_for flash_type
    { success: 'alert-success', error: 'alert-danger', warning: 'alert-warning', notice: 'alert-info', alert: "alert-danger"}[flash_type.to_sym]
  end

  def insert_fields_data(f, title, name)
    fields = render(title+ "_fields", f: f)
    {name => fields.gsub("\n", "")}
  end

  def datatable_language
    if I18n.exists?("table_text.sInfoFiltered")
      {
          "sProcessing"=>    t("table_text.sProcessing"),
          "sLengthMenu"=>    t("table_text.sLengthMenu"),
          "sZeroRecords"=>   t("table_text.sZeroRecords"),
          "sEmptyTable"=>    t("table_text.sEmptyTable"),
          "sInfo"=>          t("table_text.sInfo"),
          "sInfoEmpty"=>     t("table_text.sInfoEmpty"),
          "sInfoFiltered"=>  t("table_text.sInfoFiltered"),
          "sInfoPostFix"=>   t("table_text.sInfoPostFix"),
          "sSearch"=>        t("table_text.sSearch"),
          "sUrl"=>           t("table_text.sUrl"),
          "sInfoThousands"=> t("table_text.sInfoThousands"),
          "sLoadingRecords"=>t("table_text.sLoadingRecords"),
          "oPaginate"=> {
              "sFirst"=>    t("table_text.sFirst"),
              "sLast"=>    t("table_text.sLast"),
              "sNext"=>    t("table_text.sNext"),
              "sPrevious"=> t("table_text.sPrevious")
          },
          "oAria"=> {
              "sSortAscending"=>  t("table_text.sSortAscending"),
              "sSortDescending"=> t("table_text.sSortDescending")
          }
      }.to_json.html_safe
    else
      nil
    end
  end
end
