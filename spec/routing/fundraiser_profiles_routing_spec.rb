require "spec_helper"

describe FundraiserProfilesController do
  describe "routing" do

    it "routes to #index" do
      get("/fundraiser_profiles").should route_to("fundraiser_profiles#index")
    end

    it "routes to #new" do
      get("/fundraiser_profiles/new").should route_to("fundraiser_profiles#new")
    end

    it "routes to #show" do
      get("/fundraiser_profiles/1").should route_to("fundraiser_profiles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fundraiser_profiles/1/edit").should route_to("fundraiser_profiles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fundraiser_profiles").should route_to("fundraiser_profiles#create")
    end

    it "routes to #update" do
      put("/fundraiser_profiles/1").should route_to("fundraiser_profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fundraiser_profiles/1").should route_to("fundraiser_profiles#destroy", :id => "1")
    end

  end
end
