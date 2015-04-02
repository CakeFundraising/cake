module CakesterCommissionable
  extend ActiveSupport::Concern

  included do
    has_one :cakester_commission_setting, as: :commissionable, class_name:'CakesterCommission'
    accepts_nested_attributes_for :cakester_commission_setting, update_only: true, reject_if: :all_blank
    validates_associated :cakester_commission_setting

    after_initialize do
      self.build_cakester_commission_setting if self.cakester_commission_setting.blank?
    end
  end
end