require "rails_helper"

RSpec.describe CakestersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/cakesters").to route_to("cakesters#index")
    end

    it "routes to #new" do
      expect(:get => "/cakesters/new").to route_to("cakesters#new")
    end

    it "routes to #show" do
      expect(:get => "/cakesters/1").to route_to("cakesters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/cakesters/1/edit").to route_to("cakesters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/cakesters").to route_to("cakesters#create")
    end

    it "routes to #update" do
      expect(:put => "/cakesters/1").to route_to("cakesters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/cakesters/1").to route_to("cakesters#destroy", :id => "1")
    end

  end
end
