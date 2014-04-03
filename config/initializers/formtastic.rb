Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder

class Formtastic::Inputs::SelectInput
  def extra_input_html_options
    { multiple: multiple?,
      class: 'chosen-select',
      name: (multiple? && Rails::VERSION::MAJOR >= 3) ? input_html_options_name_multiple : input_html_options_name }
  end
end