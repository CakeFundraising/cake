Formtastic::FormBuilder.action_class_finder = Formtastic::ActionClassFinder
Formtastic::FormBuilder.input_class_finder = Formtastic::InputClassFinder

Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder
# Define custom namespaces in which to look up your Input classes. Default is
# to look up in the global scope and in Formtastic::Inputs.
Formtastic::FormBuilder.input_namespaces = [ ::Object, ::FormtasticBootstrap::Inputs, ::Formtastic::Inputs ]

# Define custom namespaces in which to look up your Action classes. Default is
# to look up in the global scope and in Formtastic::Actions.
Formtastic::FormBuilder.action_namespaces = [ ::Object, ::FormtasticBootstrap::Actions, ::Formtastic::Actions ]

class Formtastic::Inputs::SelectInput
  def extra_input_html_options
    { multiple: multiple?, name: (multiple? && Rails::VERSION::MAJOR >= 3) ? input_html_options_name_multiple : input_html_options_name }
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