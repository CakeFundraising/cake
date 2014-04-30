class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?(:sponsor)
      #Pledge
      can :create, Pledge
      can [:edit, :update, :destroy] + PledgesController::WIZARD_STEPS, Pledge, sponsor_id: user.sponsor.id

      #PledgeRequest
      can [:accept, :reject], PledgeRequest      
    end

    if user.has_role?(:fundraiser)
      #Campaign
      can :create, Campaign
      can [:edit, :update, :destroy] + CampaignsController::WIZARD_STEPS, Campaign, fundraiser_id: user.fundraiser.id
      
      #PledgeRequest
      can :create, PledgeRequest
      can [:edit, :update, :destroy], PledgeRequest, fundraiser_id: user.fundraiser.id
      
      #Pledge
      can [:accept, :reject], Pledge      
    end

    can :read, :all
    can [:pledge, :badge], Campaign
  end
end
