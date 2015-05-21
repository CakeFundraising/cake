class DirectDonationsController < InheritedResources::Base
  def create
    @direct_donation = DirectDonation.new(permitted_params[:direct_donation])

    create! do |success, failure|
      success.html do
        flash[:notice] = nil
        redirect_to polymorphic_path(@direct_donation.donable, donated: 1, anchor: 'sponsors_banner')
      end
      failure.html do
        redirect_to @direct_donation.donable, alert: "There was an error with your donation, please try again."
      end
    end

  end

  protected

  def permitted_params
    params.permit(direct_donation: [:donable_id, :donable_type, :card_token, :amount, :email])
  end
end
