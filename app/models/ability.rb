class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :update, :destroy, to: :crud
    user ||= User.new

    if user.has_role?(:sponsor)
      #Sponsor
      can :create, Sponsor
      can :crud, Sponsor, id: user.sponsor.id

      #Pledge
      can :create, Pledge
      can [:update, :destroy, :launch, :increase, :set_increase, :select_campaign] + PledgesController::WIZARD_STEPS, Pledge, sponsor_id: user.sponsor.id

      #PledgeRequest
      can [:accept, :reject], PledgeRequest, sponsor_id: user.sponsor.id    
    end

    if user.has_role?(:fundraiser)
      #Fundraiser
      can :create, Fundraiser
      can :crud, Fundraiser, id: user.fundraiser.id

      #Campaign
      can :create, Campaign
      can :launch, Campaign, fundraiser_id: user.fundraiser.id
      can [:update, :destroy] + CampaignsController::WIZARD_STEPS, Campaign, fundraiser_id: user.fundraiser.id
      
      #PledgeRequest
      can :create, PledgeRequest
      can [:update, :destroy], PledgeRequest, fundraiser_id: user.fundraiser.id
      
      #Pledge
      can [:accept, :reject, :add_reject_message, :increase_request, :destroy], Pledge, fundraiser: user.fundraiser
    end

    can :read, :all
    can :badge, Campaign
    can [:badge, :solicit_click, :click, :new], Pledge
  end
end
