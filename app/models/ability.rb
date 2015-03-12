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

      can :crud, Coupon, sponsor: user.sponsor
      can :crud, PledgeNews, sponsor: user.sponsor

      #PledgeRequest
      can [:accept, :reject], PledgeRequest, sponsor_id: user.sponsor.id
    end

    if user.has_role?(:fundraiser)
      #Fundraiser
      can :create, Fundraiser
      can :crud, Fundraiser, id: user.fundraiser.id

      #Campaign
      can :create, Campaign
      can [:launch, :save_for_launch, :toggle_visibility], Campaign, fundraiser_id: user.fundraiser.id
      can [:update, :destroy] + CampaignsController::WIZARD_STEPS, Campaign, fundraiser_id: user.fundraiser.id
      
      #PledgeRequest
      can :create, PledgeRequest
      can [:update, :destroy], PledgeRequest, fundraiser_id: user.fundraiser.id

      #CakesterRequest
      can :create, CakesterRequest
      can [:update, :destroy], CakesterRequest, fundraiser_id: user.fundraiser.id
      
      #Pledge
      can [:accept, :reject, :add_reject_message, :increase_request, :destroy], Pledge, fundraiser: user.fundraiser

      #QuickPledge
      can :crud, QuickPledge, fundraiser: user.fundraiser
      #FrSponsor
      can :crud, FrSponsor, fundraiser_id: user.fundraiser.id
      
      can :destroy, CampaignCakester, fundraiser_id: user.fundraiser.id
    end

    if user.has_role?(:cakester)
      #Cakester
      can :create, Cakester
      can :crud, Cakester, id: user.cakester.id

      #CakesterRequest
      can [:accept, :reject, :reject_message, :destroy], CakesterRequest, cakester_id: user.cakester.id
      
      can :destroy, CampaignCakester, cakester_id: user.cakester.id
    end

    can :read, :all
    can :load_all, PledgeNews
    can [:badge, :hero], Campaign
    can [:download, :load_all], Coupon
    can [:badge, :solicit_click, :click, :new], Pledge
  end
end
