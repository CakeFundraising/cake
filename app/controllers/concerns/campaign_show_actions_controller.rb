module CampaignShowActionsController
  extend ActiveSupport::Concern

  included do
    before_action :redirect_to_hero_campaign, only: :show
  end

  def show
    @campaign = resource.decorate
    @custom_pledge_levels = @campaign.custom_pledge_levels

    if @custom_pledge_levels
      @sponsor_categories = resource.sponsor_categories.order(min_value_cents: :desc).decorate
      @campaign.past? ? @campaign.rank_levels(:past) : @campaign.rank_levels
    end

    if mobile_device?
      render("campaigns/show/templates/original/regular/mobile", layout: 'layouts/campaigns/mobile')
    else
      render("campaigns/show/templates/original/regular/desktop", layout: 'layouts/campaigns/desktop')
    end
  end

  def hero
    @campaign = HeroDecorator.decorate(resource)
    @pledge = HeroPledgeDecorator.decorate(@campaign.hero_pledge || @campaign.build_hero_pledge)
    
    if @pledge.present?
      @coupons = @pledge.coupons_sample.decorate 
      @news = @pledge.news_sample.decorate if @pledge.news_sample.present?
    end

    if mobile_device?
      render("campaigns/show/templates/original/hero/mobile", layout: 'layouts/campaigns/mobile')
    else
      render("campaigns/show/templates/original/hero/desktop", layout: 'layouts/campaigns/desktop')
    end
  end

  protected

  def redirect_to_hero_campaign
    redirect_to hero_campaign_path(resource, request.query_parameters) if resource.hero
  end
end