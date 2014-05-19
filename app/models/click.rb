class Click < ActiveRecord::Base
  belongs_to :pledge

  validates :request_ip, :pledge, presence: true
  validates :request_ip, uniqueness: true
end
