class HomeController < ApplicationController
  def index
  end

  def get_started
    session.delete(:new_user)
  end
end
