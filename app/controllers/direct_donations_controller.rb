class DirectDonationsController < InheritedResources::Base
  def create
    @campaign = Campaign.find(permitted_params[:direct_donation][:campaign_id])
    @direct_donation = @campaign.direct_donations.build(card_token: permitted_params[:direct_donation][:card_token])    

    create! do |success, failure|
      success.html do
        redirect_to @campaign, notice: "Thanks for contributing!"
      end
      failure.html do
        redirect_to @campaign
      end
    end
  end

  protected

  def permitted_params
    params.permit(direct_donation: [:campaign_id, :card_token])
  end
end
