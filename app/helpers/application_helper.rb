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
    ActiveRecord::Type::Boolean.new.type_cast_from_database(string)
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

  def default_meta_tags
    {
      :title       => 'Member Login',
      :description => 'Member login page.',
      :keywords    => 'Site, Login, Members',
      :separator   => "&mdash;".html_safe,
    }
  end

  def underscore_to_dash(string)
    string.gsub("_", "-")
  end

  ## Global data
  def cake_global_raised
    Invoice.paid.sum(:due_cents).to_i/100
  end

  def global_raised
    "#{currency_symbol}#{number_to_human(cake_global_raised, units: :numbers, format: '%n%u')}".html_safe
  end

  def campaigns_count
    number_to_human(Campaign.count, units: :numbers, format: '%n%u')
  end

  def sponsors_count
    number_to_human(Sponsor.count, units: :numbers, format: '%n%u')
  end
end
