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

  def buttons
    template.content_tag(:div, class:'boolean-button-container') do
      template.content_tag(:button, input_html_options[:on_text], button_options(:on) ) + 
      template.content_tag(:button, input_html_options[:off_text], button_options(:off) )
    end
  end

  def button_options(status)
    options = {type: "button", data:{value: BOOLEAN_MAPPER[status]} }.merge(button_classes(status))
    options = options.merge({data: {value: BOOLEAN_MAPPER[status], toggle: "collapse", parent: input_html_options[:collapsible][:parent], target: "##{status}_collapse_panel"}, aria: {expanded: "false", controls: "#{status}_collapse"} }) if input_html_options[:collapsible].present?
    options
  end

  def button_classes(status)
    classes = input_html_options[:"#{status}_classes"]
    {class: "btn boolean-button-input #{classes} #{'active' if BOOLEAN_MAPPER[object.send(method).to_s.to_sym] == status }"}
  end
end