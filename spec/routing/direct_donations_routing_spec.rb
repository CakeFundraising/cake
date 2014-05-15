require "spec_helper"

describe DirectDonationsController do
  describe "routing" do

    it "routes to #index" do
      get("/direct_donations").should route_to("direct_donations#index")
    end

    it "routes to #new" do
      get("/direct_donations/new").should route_to("direct_donations#new")
    end

    it "routes to #show" do
      get("/direct_donations/1").should route_to("direct_donations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/direct_donations/1/edit").should route_to("direct_donations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/direct_donations").should route_to("direct_donations#create")
    end

    it "routes to #update" do
      put("/direct_donations/1").should route_to("direct_donations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/direct_donations/1").should route_to("direct_donations#destroy", :id => "1")
    end

  end
end
