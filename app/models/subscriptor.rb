class Subscriptor < ActiveRecord::Base
  validates :email, presence: true
  validates :email, email: true

  belongs_to :object, polymorphic: true
end
