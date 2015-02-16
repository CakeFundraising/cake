require 'rails_helper'

RSpec.describe "Cakesters", :type => :request do
  describe "GET /cakesters" do
    it "works! (now write some real specs)" do
      get cakesters_path
      expect(response).to have_http_status(200)
    end
  end
end
