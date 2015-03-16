module Messagable
  extend ActiveSupport::Concern

  included do
    class_attribute :messagable_action
  end

  module ClassMethods
    def messagable(action, template_path=nil)
      self.messagable_action = action

      define_method(:"#{action}_message") do
        render(template_path || "#{action}_message")
      end
    end
  end
end