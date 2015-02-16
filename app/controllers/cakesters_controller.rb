class CakestersController < InheritedResources::Base

  private

    def cakester_params
      params.require(:cakester).permit(:name, :email, :phone, :website, :manager_name, :manager_email, :manager_title, :manager_phone, :mission, :about, :causes_mask, :scopes_mask, :cause_requirements_mask, :email_subscribers, :facebook_subscribers, :twitter_subscribers, :pinterest_subscribers)
    end
end

