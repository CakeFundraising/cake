class SearchesController < ApplicationController
  def search_campaigns
  	facets = [:zip_code, :causes, :scopes]

    @search = Campaign.solr_search do
      fulltext params[:search]
      #with(:status, [:active, :locked])
      paginate page: params[:page], per_page: 20

      facets.each do |f|
        send(:facet, f)
        send(:with, f, params[f]) if params[f].present?
      end
    end

    @facets = facets

    if params[:search].nil?
      @campaigns = CampaignDecorator.decorate_collection @search.results
      render "searches/campaigns/index"
    else
      @campaigns = @search.results.blank? ? Campaign.first(20) : @search.results
      render partial: "campaigns/show/grid", collection: CampaignDecorator.decorate_collection(@campaigns), as: :campaign
    end
  end
end
