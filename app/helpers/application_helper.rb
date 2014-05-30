module ApplicationHelper
  def active_in_page(path)
    "active" if current_page?(path)
  end

  def b(value, options = {})
    options = {
      :true => :yes,
      :false => :no,
      :scope => [:boolean],
      :locale => I18n.locale
    }.merge options

    boolean = !!value
    key = boolean.to_s.to_sym

    t(options[key], :scope => options[:scope], :locale => options[:locale])
  end

  def basic_list_item(name, value)
    content_tag(:div, class: name) do
      content_tag(:span, name)+
      content_tag(:strong, value, class:'pull-right')
    end
  end

  def auto_link(object)
    link_to object.to_s, object
  end
end
