class BooleanButtonInput < Formtastic::Inputs::BooleanInput

  BOOLEAN_MAPPER = {
    on: 1,
    off: 0,
    true: :on,
    false: :off
  }

  def to_html
    input_wrapping do
      hidden_field_html <<
      buttons
    end
  end

  def input_wrapping(&block)
    template.content_tag(:div,
      [template.capture(&block), error_html, hint_html].join("\n").html_safe,
      wrapper_html_options
    )
  end

  #Hidden field
  def hidden_field_html
    template.hidden_field_tag(input_html_options[:name], hidden_field_value, id: nil, disabled: input_html_options[:disabled] )
  end

  def hidden_field_value
    BOOLEAN_MAPPER[BOOLEAN_MAPPER[object.send(method).to_s.to_sym]]
  end

  #Buttons
  def buttons
    template.content_tag(:div, class:'boolean-button-container') do
      template.content_tag(:button, input_html_options[:on_text], button_options(:on) ) + 
      template.content_tag(:span, (input_html_options[:middle_text] || '').html_safe) +
      template.content_tag(:button, input_html_options[:off_text], button_options(:off) )
    end
  end

  def button_options(status)
    options = {type: "button", data:{value: BOOLEAN_MAPPER[status], on_classes: input_html_options[:on_classes], off_classes: input_html_options[:off_classes]} }.merge(button_classes(status))
    
    options = options.merge({
      data: {
        value: BOOLEAN_MAPPER[status], 
        on_classes: input_html_options[:on_classes], 
        off_classes: input_html_options[:off_classes], 
        toggle: "collapse", 
        parent: input_html_options[:collapsible][:parent], 
        target: input_html_options[:collapsible][:"#{status}_panel"]
      }, 
      aria: {expanded: "false", controls: "#{status}_collapse"}
    }) if input_html_options[:collapsible].present?

    options
  end

  def button_classes(status)
    field_value = object.send(method)

    # If and only if statements
    if (field_value and status == :on) or (not field_value and status == :off)
      classes = input_html_options[:on_classes]
    elsif (field_value and status == :off) or (not field_value and status == :on)
      classes = input_html_options[:off_classes]
    end

    {class: "btn boolean-button-input #{classes}"}
  end
end