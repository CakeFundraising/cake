class HomeController < ApplicationController
  before_action :go_to_registration, only: :index
  before_action :block_registered_user, only: :get_started

  def index
    @carousel_pics = (Sponsor.home_logos + Fundraiser.home_logos).shuffle
    p @carousel_pics.count
    @campaigns = CampaignDecorator.decorate_collection Campaign.popular
  end

  def get_started
    session.delete(:new_user)
  end

  def load_tab
    model = params[:model].camelize

    @collection = "#{model}Decorator".constantize.decorate_collection model.constantize.popular
    render partial:"home/search/#{params[:model].pluralize}"
  end

  protected

  def block_registered_user
    redirect_to root_path if current_user.nil? or current_user.registered
  end

  def go_to_registration
    unless current_user.nil? || current_user.registered
      if current_user.fundraiser_email_setting.present? and current_fundraiser.nil?
        route = new_fundraiser_path
      elsif current_user.sponsor_email_setting.present? and current_sponsor.nil?
        route = new_sponsor_path
      else
        route = home_get_started_path
      end

      redirect_to route, notice: 'Please complete your registration in CakeCauseMarketing.'
    end
  end
end
