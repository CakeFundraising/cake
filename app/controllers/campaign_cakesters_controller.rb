class CampaignCakestersController < InheritedResources::Base
  def destroy
    destroy! do |success, failure|
      success.html do
        path = current_fundraiser.present? ? fundraiser_campaigns_path : cakester_campaigns_path
        message = current_fundraiser.present? ? 'Cakester removed.' : 'Campaign removed.'

        redirect_to path, notice: message
      end
    end
  end
end