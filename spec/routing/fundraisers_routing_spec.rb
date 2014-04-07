require "spec_helper"

describe FundraisersController do
  describe "routing" do

    it "routes to #index" do
      get("/fundraisers").should route_to("fundraisers#index")
    end

    it "routes to #new" do
      get("/fundraisers/new").should route_to("fundraisers#new")
    end

    it "routes to #show" do
      get("/fundraisers/1").should route_to("fundraisers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fundraisers/1/edit").should route_to("fundraisers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fundraisers").should route_to("fundraisers#create")
    end

    it "routes to #update" do
      put("/fundraisers/1").should route_to("fundraisers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fundraisers/1").should route_to("fundraisers#destroy", :id => "1")
    end

  end
end
