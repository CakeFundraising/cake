class SubscriptorsController < InheritedResources::Base
  def create
    create! do |success, failure|
      success.html do
        redirect_to object, notice: "Thanks for following us! We'll be in touch soon."
      end
    end
  end

  private

  def object
    params[:subscriptor][:object_type].constantize.find(params[:subscriptor][:object_id])
  end

  def permitted_params
    params.permit(
      subscriptor: [:first_name, :last_name, :email, :object_type, :object_id]
    )
  end
end