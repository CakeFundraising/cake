class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?(:sponsor)
      #Pledge
      can :create, Pledge
      can [:edit, :update, :destroy], Pledge, sponsor_id: user.sponsor.id
    end

    if user.has_role?(:fundraiser)
      #Campaign
      can :create, Campaign
      can [:edit, :update, :destroy], Campaign, fundraiser_id: user.fundraiser.id
      
      #PledgeRequest
      can :create, PledgeRequest
      can [:edit, :update, :destroy], PledgeRequest, fundraiser_id: user.fundraiser.id
    end
    
    can :read, :all
  end
end
