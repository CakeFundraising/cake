class UploaderInput < Formtastic::Inputs::FileInput
  def to_html
    input_wrapping do
      picture_html <<
      hidden_field_html
    end
  end

  def input_wrapping(&block)
    template.content_tag(:div,
      [template.capture(&block), error_html, hint_html].join("\n").html_safe,
      wrapper_html_options
    )
  end

  def picture_html
    template.content_tag(:div, class: method.to_s) do
      object.decorate.send(method) +
      upload_button
    end
  end

  def upload_button
    template.content_tag(:button, "Upload Picture", class:'btn btn-lg upload-button')
  end

  def hidden_field_html
    builder.input method, as: :hidden, input_html:{class: 'uri_input'}
  end
end