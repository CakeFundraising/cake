class Subscriptor < ActiveRecord::Base
  validates :email, :message, presence: true
  validates :email, email: true

  belongs_to :object, polymorphic: true
  belongs_to :origin, polymorphic: true

  after_create do
    UserNotification.new_subscriptor(self.id).deliver
  end
end
