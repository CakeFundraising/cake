require "spec_helper"

describe QuickPledgesController do
  describe "routing" do

    it "routes to #index" do
      get("/quick_pledges").should route_to("quick_pledges#index")
    end

    it "routes to #new" do
      get("/quick_pledges/new").should route_to("quick_pledges#new")
    end

    it "routes to #show" do
      get("/quick_pledges/1").should route_to("quick_pledges#show", :id => "1")
    end

    it "routes to #edit" do
      get("/quick_pledges/1/edit").should route_to("quick_pledges#edit", :id => "1")
    end

    it "routes to #create" do
      post("/quick_pledges").should route_to("quick_pledges#create")
    end

    it "routes to #update" do
      put("/quick_pledges/1").should route_to("quick_pledges#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/quick_pledges/1").should route_to("quick_pledges#destroy", :id => "1")
    end

  end
end
