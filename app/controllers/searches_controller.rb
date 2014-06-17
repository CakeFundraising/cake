class SearchesController < ApplicationController
  def search_campaigns
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
      render "searches/campaigns/index"
    else
      render partial: "campaigns/show/grid", collection: @campaigns, as: :campaign
    end
  end
end
