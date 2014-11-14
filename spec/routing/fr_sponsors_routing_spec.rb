require "spec_helper"

describe FrSponsorsController do
  describe "routing" do

    it "routes to #index" do
      get("/fr_sponsors").should route_to("fr_sponsors#index")
    end

    it "routes to #new" do
      get("/fr_sponsors/new").should route_to("fr_sponsors#new")
    end

    it "routes to #show" do
      get("/fr_sponsors/1").should route_to("fr_sponsors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fr_sponsors/1/edit").should route_to("fr_sponsors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fr_sponsors").should route_to("fr_sponsors#create")
    end

    it "routes to #update" do
      put("/fr_sponsors/1").should route_to("fr_sponsors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fr_sponsors/1").should route_to("fr_sponsors#destroy", :id => "1")
    end

  end
end
