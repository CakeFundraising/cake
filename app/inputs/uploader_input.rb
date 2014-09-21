# A formtastic input which incorporates carrierwave uploader functionality.
#
# Intelligently adds the cache field, displays and links to the current
# value if there is one, adds a class to the wrapper when replacing an
# existing value, allows removing an existing value with the checkbox
# taking into account validation requirements.
#
# There are several options:
#
#  * Toggle the replacement field with `replaceable: true/false`.
#  * The replace file label is translatable as `replace_label` or using option `replace_label: "value"` (like `label`).
#  * Toggle the remove checkbox with `removable: true/false` (`true` overrides `required`).
#  * The remove checkbox label is translatable as `remove_label` or using option `remove_label: "value"` (like `label`).
#  * Override existing file display and links using `existing_html` and `existing_link_html` (like `wrapper_html`).
#
# Example: `form.input :file, as: "uploader"`
class UploaderInput < Formtastic::Inputs::FileInput
  def linkable?
    options[:linkable] != false
  end

  def replaceable?
    options[:replaceable] != false
  end

  def removable?
    options[:removable] != false and (options[:removable] == true or not required?)
  end

  def method_present?
    if object.respond_to?("#{method}?")
      object.send("#{method}?")
    else
      object.send(method).present?
    end
  end

  def method_changed?
    if object.respond_to? "#{method}_changed?"
      object.send "#{method}_changed?"
    else
      false
    end
  end

  def method_was_present?
    if not method_changed?
      method_present?
    else
      object.send("#{method}_was").present?
    end
  end

  def wrapper_html_options
    super.tap do |options|
      options[:class] << " replaceable" if replaceable?
      options[:class] << " removable" if removable?
      options[:class] << " present" if method_present?
      options[:class] << " changed" if method_changed?
      options[:class] << " was_present" if method_was_present?
      options[:class] << " has-error" if errors?
    end
  end

  def cache_html
    if method_changed?
      builder.hidden_field("#{method}_cache")
    end or "".html_safe
  end

  def file_html
    #builder.file_field(method, input_html_options)
    builder.cl_image_upload(method)
  end

  def input_html_options
    {
      class: "#{method}_input cloudinary-fileupload",
      name: :field,
      crop: (object.persisted?)
      #crop: false
    }.merge(
      :"data-url" => template.cl_upload_url,
      :"data-form-data" => template.cl_upload_tag_params,
      :"data-cloudinary-field" => "#{object_name}[#{method}]"
    )
  end

  def existing_html_options
    expand_html_options(options[:existing_html]) do |opts|
      opts[:class] << "existing"
    end
  end

  def existing_link_html_options
    expand_html_options(options[:existing_link_html]) do |opts|
      opts[:class] << "existing"
    end
  end

  def existing_html
    medium_size = "Picture::#{method.upcase}_SIZES".constantize[:medium]

    template.content_tag(:div, class: method.to_s) do
      object.decorate.send(method)
      #template.cl_image_tag(object.send(method), crop: :fill, width: medium_size.first, height: medium_size.last, class:'img-responsive img-thumbnail')
    end
  end

  def replace_label_html
    template.content_tag(:label, class: "replace_label") do
      template.content_tag(:span, localized_string(method, "Replace #{method.to_s.titleize}", :replace_label))
    end
  end

  def replace_html
    if replaceable?
      # replace_label_html <<
      file_html
    end or "".html_safe
  end

  def remove_html
    if removable? and object.send(method).present?
      template.content_tag(:label, class: "remove_label pull-right") do
        template.check_box_tag("#{object_name}[remove_#{method}]", "1", false, id: "#{sanitized_object_name}_remove_#{sanitized_method_name}") <<
        # XXX: There are probably better ways to do these translations using defaults.
        template.content_tag(:span, localized_string(method, " Remove", :remove_label))
      end
    end or "".html_safe
  end

  def label_html
    template.content_tag(:label, class:'control-label') do
      object.class.human_attribute_name(method)
    end
  end

  def builder_parent
    options[:parent] || builder
  end

  def errors?
    builder_parent.object.errors.messages[method].present?
  end

  def errors_html
    template.content_tag(:span, builder_parent.object.errors.messages[method].join(", "), class:"has-error help-block") if errors?
  end

  def to_html
    input_wrapping do
      remove_html <<
      #label_html <<
      errors_html <<
      #cache_html <<
      if method_was_present?
        existing_html <<
        replace_html
      else
        existing_html <<
        file_html
      end  
    end
  end

protected

  def expand_html_options opts
    (opts || {}).dup.tap do |opts|
      opts[:class] =
        case opts[:class]
        when Array
          opts[:class].dup
        when nil
          []
        else
          [opts[:class].to_s]
        end
      opts[:data] =
        case opts[:data]
        when Hash
          opts[:data].dup
        when nil
          {}
        else
          {"" => opts[:data].to_s}
        end

      yield opts if block_given?

      opts[:class] = opts[:class].join(' ')
    end
  end
end