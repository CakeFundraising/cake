require "spec_helper"

describe PublicProfilesController do
  describe "routing" do

    it "routes to #index" do
      get("/public_profiles").should route_to("public_profiles#index")
    end

    it "routes to #new" do
      get("/public_profiles/new").should route_to("public_profiles#new")
    end

    it "routes to #show" do
      get("/public_profiles/1").should route_to("public_profiles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/public_profiles/1/edit").should route_to("public_profiles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/public_profiles").should route_to("public_profiles#create")
    end

    it "routes to #update" do
      put("/public_profiles/1").should route_to("public_profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/public_profiles/1").should route_to("public_profiles#destroy", :id => "1")
    end

  end
end
