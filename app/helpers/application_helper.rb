module ApplicationHelper
  def active_in_page(path1, path2=nil)
    return "active" if path2.nil? and current_page?(path1)
    "active" if current_page?(path1) or current_page?(path2)
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
end
