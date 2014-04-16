class Sponsor::DashboardController < ApplicationController
  def home
    @sponsor = current_sponsor
  end

  def billing
  end

  def pledge_requests
  end

  def active_pledges
  end

  def history
  end
end