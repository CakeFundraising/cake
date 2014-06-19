module SearchableController
  extend ActiveSupport::Concern

  def campaigns_search
    facets = [:zip_code, :causes, :scopes, :tax_exempt, :active]

    @search = Campaign.solr_search(include: [:picture]) do
      fulltext params[:search]
      paginate page: params[:page], per_page: 20

      facets.each do |f|
        send(:facet, f)
        
        if params[f].present?
          if view_context.is_boolean?(params[f])
            send(:with, f, view_context.to_boolean(params[f]) ) 
          else
            send(:with, f, params[f]) 
          end
        end
      end

    end

    @facets = facets
    @campaigns = CampaignDecorator.decorate_collection @search.results

    if params[:search].nil?
      render "searches/campaigns"
    else
      render "searches/campaigns", layout: false
    end
  end

  def sponsors_search
    facets = [:zip_code, :causes, :scopes]

    @search = Sponsor.solr_search(include: [:picture]) do
      fulltext params[:search]
      paginate page: params[:page], per_page: 20

      facets.each do |f|
        send(:facet, f)
        send(:with, f, params[f]) if params[f].present?
      end
    end

    @facets = facets
    @sponsors = SponsorDecorator.decorate_collection @search.results

    if params[:search].nil?
      render "searches/sponsors"
    else
      render "searches/sponsors", layout: false
    end
  end

  def coupons_search
    facets = [:zip_code, :merchandise_categories]

    @search = Coupon.solr_search do
      fulltext params[:search]
      paginate page: params[:page], per_page: 20

      facets.each do |f|
        send(:facet, f)
        send(:with, f, params[f]) if params[f].present?
      end
    end

    @facets = facets
    @coupons = CouponDecorator.decorate_collection @search.results

    if params[:search].nil?
      render "searches/coupons"
    else
      render "searches/coupons", layout: false
    end
  end
end