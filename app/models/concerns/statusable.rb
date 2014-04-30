module Statusable
  extend ActiveSupport::Concern

  module ClassMethods
    def has_statuses(*statuses)
      opts = { column_name: :status }.merge statuses.extract_options!
      (self.statuses ||= {})[opts[:column_name]] = statuses

      self.statuses[opts[:column_name]].each do |status|
        define_method(:"#{status}?") { self.send(opts[:column_name]).to_s.to_sym == status }
        define_method(:"not_#{status}?") { self.send(opts[:column_name]).to_s.to_sym != status }
        define_method(:"#{status}!"){ self.update_attribute(opts[:column_name], status) }
        scope status, -> { where opts[:column_name] => status }
        scope :"not_#{status}", -> { where.not opts[:column_name] => status }
      end
    end
  end

  included do
    class_attribute :statuses
  end
end