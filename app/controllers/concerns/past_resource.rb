module PastResource
  extend ActiveSupport::Concern

  included do
    before_action :check_if_past, only: self::WIZARD_STEPS + [:edit, :update]
  end

  protected

  def check_if_past
    redirect_to resource, alert: "This is a past #{resource.class.name.downcase}. It cannot be edited." if resource.past?
  end
end