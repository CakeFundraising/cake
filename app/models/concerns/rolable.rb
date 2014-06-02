module Rolable
  extend ActiveSupport::Concern

  included do
    class_attribute :roles_list
    scope :with_role, ->(role) do
      where "roles_mask & #{2 ** roles_list.index(role)} > 0"
    end
  end

  module ClassMethods
    def has_roles(roles_array)
      self.roles_list = roles_array

      self.roles_list.each do |role|
        define_method(:"#{role}?") { has_role? role }
        define_method(:"not_#{role}?") { !has_role?(role) }
      end

      include InstanceMethods
    end
  end

  module InstanceMethods
    def roles=(roles)
      self.roles_mask = (roles.map(&:to_sym) & roles_list).map { |r|
        2**roles_list.index(r)
      }.inject(0, :+)
    end

    def roles
      roles_list.reject do |r|
        ((roles_mask.to_i || 0) & 2**roles_list.index(r)).zero?
      end
    end

    def has_role?(role)
      if role.is_a?(Symbol)
        roles.include?(role)
      else
        !(roles & role).empty?
      end
    end
  end
end
