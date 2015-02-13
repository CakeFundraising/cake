class PledgeNewsController < InheritedResources::Base
  load_and_authorize_resource

  def new
    @pledge_news = PledgeNews.new(pledge_id: params[:pledge_id])
    @pledge = Pledge.find(params[:pledge_id])
    authorize! :new, @pledge_news
  end

  def edit
    @pledge = resource.pledge
  end

  def create
    p resource
    create! do |success, failure|
      success.html do
        redirect_to news_pledge_path(resource.pledge)
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to news_pledge_path(resource.pledge)
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html do
        redirect_to news_pledge_path(resource.pledge)
      end
    end
  end

  def load_all
    @pledge = Pledge.find(params[:pledge_id]).decorate
    @news = PledgeNewsDecorator.decorate_collection @pledge.pledge_news.latest.offset(1)
    @partial = params[:partial]

    @news.any? ? render(:load_all, layout: false) : render(nothing: true)
  end

  def permitted_params
    params.permit(
      pledge_news: [
        :id, :headline, :story, :avatar, :pledge_id, :url, :_destroy, :qrcode, :qrcode_cache,
        picture_attributes: [
          :id, :banner, :avatar, :qrcode, :avatar_caption,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h,
          :qrcode_crop_x, :qrcode_crop_y, :qrcode_crop_w, :qrcode_crop_h
        ]
      ]
    )
  end
end