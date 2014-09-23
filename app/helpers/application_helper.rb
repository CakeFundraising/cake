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

  def to_boolean(string)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(string)
  end

  def is_boolean?(string)
    ['true', 'false'].include?(string)
  end

  def basic_list_item(name, value)
    content_tag(:div, class: name) do
      content_tag(:span, name, class:'boldest')+
      content_tag(:span, value, class:'pull-right')
    end
  end

  def auto_link(object, opts={})
    if opts.symbolize_keys![:truncate].present?
      link_to truncate(object.to_s, length: opts[:truncate]), object, opts
    else
      link_to object.to_s, object, opts
    end
  end

  def auto_attr_link(attribute, opts={})
    link_to attribute, attribute, opts.symbolize_keys
  end

  def auto_mail(object)
    mail_to object.email, object.email
  end
end
