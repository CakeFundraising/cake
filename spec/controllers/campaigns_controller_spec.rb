require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe CampaignsController do
  login_fundraiser
  # This should return the minimal set of attributes required to create a valid
  # Campaign. As you add validations to Campaign, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for(:campaign).merge({fundraiser_id: @fundraiser.id}) }

  describe "GET index" do
    it "assigns all campaigns as @campaigns" do
      campaign = Campaign.create! valid_attributes
      get :index
      assigns(:campaigns).should eq([campaign])
    end
  end

  describe "GET show" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :show, :id => campaign.to_param
      assigns(:campaign).should eq(campaign)
    end
  end

  describe "GET new" do
    it "assigns a new campaign as @campaign" do
      get :new
      assigns(:campaign).should be_a_new(Campaign)
    end
  end

  describe "GET edit" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :edit, :id => campaign.to_param
      assigns(:campaign).should eq(campaign)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Campaign" do
        expect {
          post :create, :campaign => valid_attributes
        }.to change(Campaign, :count).by(1)
      end

      it "assigns a newly created campaign as @campaign" do
        post :create, :campaign => valid_attributes
        assigns(:campaign).should be_a(Campaign)
        assigns(:campaign).should be_persisted
      end

      it "redirects to tell your story for the newly created campaign" do
        post :create, :campaign => valid_attributes
        response.should redirect_to tell_your_story_campaign_path(Campaign.last)
      end
    end

    describe "with invalid params" do
      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        campaign = Campaign.create! valid_attributes
        post :create, :campaign => { "title" => "MyString" }
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested campaign" do
        campaign = Campaign.create! valid_attributes
        # Assuming there are no other campaigns in the database, this
        # specifies that the Campaign created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        put :update, :id => campaign.to_param, :campaign => { "title" => "MyString", "step" => campaign.step }
      end

      it "assigns the requested campaign as @campaign" do
        campaign = Campaign.create! valid_attributes
        put :update, :id => campaign.to_param, :campaign => valid_attributes
        assigns(:campaign).should eq(campaign)
      end

      it "redirects to the campaign" do
        campaign = Campaign.create! valid_attributes
        Campaign.any_instance.stub(:save).and_return(false)
        put :update, :id => campaign.to_param, :campaign => valid_attributes
        response.should redirect_to edit_campaign_url(campaign) + "/" + campaign.step
      end
    end

    describe "with invalid params" do
      it "assigns the campaign as @campaign" do
        campaign = Campaign.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Campaign.any_instance.stub(:save).and_return(false)
        put :update, :id => campaign.to_param, :campaign => { "title" => "" }
        assigns(:campaign).should eq(campaign)
      end

      it "re-renders the 'edit' template" do
        campaign = Campaign.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Campaign.any_instance.stub(:save).and_return(false)
        put :update, :id => campaign.to_param, :campaign => { "title" => "", "step" => campaign.step }
        response.should redirect_to edit_campaign_url(campaign) + "/" + campaign.step
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested campaign" do
      campaign = Campaign.create! valid_attributes
      expect {
        delete :destroy, :id => campaign.to_param
      }.to change(Campaign, :count).by(-1)
    end

    it "redirects to the campaigns list" do
      campaign = Campaign.create! valid_attributes
      delete :destroy, :id => campaign.to_param
      response.should redirect_to(fundraiser_campaigns_url)
    end
  end

end
