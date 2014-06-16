class ApplicationDecorator < Draper::Decorator
  delegate_all

  def created_at
    object.created_at.strftime("%B %d, %Y")
  end

  def updated_at
    object.updated_at.strftime("%B %d, %Y")
  end
    
  def prettify_boolean value
    value ? ("&#10003;").html_safe : ("&#10007;").html_safe
  end  

  def self.collection_decorator_class
    PaginatingDecorator
  end
end