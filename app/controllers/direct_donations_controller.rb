class DirectDonationsController < InheritedResources::Base
  def create
    @fundraiser = Fundraiser.find(permitted_params[:direct_donation][:fundraiser_id])
    @direct_donation = @fundraiser.direct_donations.build(permitted_params[:direct_donation])

    @campaign
    if permitted_params[:direct_donation][:campaign_id].present?
      @campaign = Campaign.find(permitted_params[:direct_donation][:campaign_id])
    end

    create! do |success, failure|
      success.html do
        if @campaign
          redirect_to @campaign, notice: "Thanks for contributing!"
        else
          redirect_to @fundraiser, notice: "Thanks for contributing!"
        end
      end
      failure.html do
        if @campaign
          redirect_to @campaign, alert: "There was an error with your donation, please try again."
        else
          redirect_to @fundraiser, alert: "There was an error with your donation, please try again."
        end
      end
    end
  end

  protected

  def permitted_params
    params.permit(direct_donation: [:fundraiser_id, :campaign_id, :card_token, :amount, :email])
  end
end
