module Picturable
  extend ActiveSupport::Concern

  included do
    has_one :picture, as: :picturable, dependent: :destroy
    accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
    delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture
    validates_associated :picture

    scope :with_picture, ->{ eager_load(:picture) }

    after_initialize do
      self.build_picture if self.new_record? and picture.blank?
    end

  end
end