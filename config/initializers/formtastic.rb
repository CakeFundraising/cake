Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder

class Formtastic::Inputs::SelectInput
  def extra_input_html_options
    { multiple: multiple?,
      class: 'chosen-select',
      name: (multiple? && Rails::VERSION::MAJOR >= 3) ? input_html_options_name_multiple : input_html_options_name }
  end
end

module Formtastic
  module Inputs
    module Base
      module Wrapping
        def input_wrapping(&block)
          template.content_tag(input_html_options[:wrapper_tag] || :li,
            [template.capture(&block), error_html, hint_html].join("\n").html_safe,
            wrapper_html_options
          )
        end
      end
    end
  end
end