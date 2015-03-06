module Clickable
  extend ActiveSupport::Concern

  included do
    has_many :extra_clicks, as: :clickable
    accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank

    validates_associated :extra_clicks
  end
end