class Campaign < ActiveRecord::Base
  include Statusable

  belongs_to :fundraiser

  has_statuses :private, :public, :launched
end
