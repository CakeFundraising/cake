class Browser < ActiveRecord::Base
  belongs_to :user

  validates :token, presence: true
end
