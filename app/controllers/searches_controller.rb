class SearchesController < ApplicationController
  def search_campaigns
    facets = [:zip_code, :main_cause, :scopes, :tax_exempt, :active]

    @search = Campaign.solr_search(include: [:picture]) do
      fulltext params[:search]
      without :status, [:incomplete, :past]
      with :visible, true
      order_by :created_at, :desc
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

    if request.xhr?
      render "searches/campaigns", layout: false
    else
      render "searches/campaigns"
    end
  end

  def search_sponsors
    facets = [:zip_code, :causes, :scopes]

    @search = Sponsor.solr_search(include: [:picture]) do
      fulltext params[:search]
      order_by :created_at, :desc
      paginate page: params[:page], per_page: 20

      facets.each do |f|
        send(:facet, f)
        send(:with, f, params[f]) if params[f].present?
      end
    end

    @facets = facets
    @sponsors = SponsorDecorator.decorate_collection @search.results

    if request.xhr?
      render "searches/sponsors", layout: false
    else
      render "searches/sponsors"
    end
  end

  def search_coupons
    facets = [:zip_code, :merchandise_categories]

    @search = Coupon.solr_search do
      fulltext params[:search]
      order_by :created_at, :desc
      paginate page: params[:page], per_page: 20

      facets.each do |f|
        send(:facet, f)
        send(:with, f, params[f]) if params[f].present?
      end
    end

    @facets = facets
    @coupons = CouponDecorator.decorate_collection @search.results

    if request.xhr?
      render "searches/coupons", layout: false
    else
      render "searches/coupons"
    end
  end
end
