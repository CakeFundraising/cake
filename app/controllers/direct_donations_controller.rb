class DirectDonationsController < InheritedResources::Base
  def create
    @campaign = Campaign.find(permitted_params[:direct_donation][:campaign_id])
    @direct_donation = @campaign.direct_donations.build(permitted_params[:direct_donation])    

    create! do |success, failure|
      success.html do
        redirect_to @campaign, notice: "Thanks for contributing!"
      end
      failure.html do
        redirect_to @campaign, alert: "There was an error with your donation, please try again.."
      end
    end
  end

  protected

  def permitted_params
    params.permit(direct_donation: [:campaign_id, :card_token, :amount, :email])
  end
end
