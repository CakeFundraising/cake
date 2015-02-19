require 'rails_helper'

describe User do
  it { should belong_to(:role) }

  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  context 'Fundraiser user' do
    let(:user){ FactoryGirl.create(:fundraiser_user) }
    let(:fundraiser){ FactoryGirl.create(:fundraiser) }

    it "should have the fundraiser role" do
      expect(user.has_role?(:fundraiser)).to be true
      expect(user.has_role?(:sponsor)).to be false
      expect(user.has_role?(:cakester)).to be false
    end
    
    describe "#set_role" do
      it "should allow the user to set fundraiser he's related to" do
        expect(user.role).to be_nil
        user.set_role(fundraiser)
        expect(user.role).to eq fundraiser
        expect(user.registered).to be true
        expect(user.roles).to eq [:fundraiser]
      end
    end
  end

  context 'Sponsor user' do
    let(:user){ FactoryGirl.create(:sponsor_user) }
    let(:sponsor){ FactoryGirl.create(:sponsor) }

    it "should have the sponsor role" do
      expect(user.has_role?(:sponsor)).to be true
      expect(user.has_role?(:fundraiser)).to be false
      expect(user.has_role?(:cakester)).to be false
    end
    
    describe "#set_role" do
      it "should allow the user to set sponsor he's related to" do
        expect(user.role).to be_nil
        user.set_role(sponsor)
        expect(user.role).to eq sponsor
        expect(user.registered).to be true
        expect(user.roles).to eq [:sponsor]
      end
    end
  end

  context 'Cakester user' do
    let(:user){ FactoryGirl.create(:cakester_user) }
    let(:cakester){ FactoryGirl.create(:cakester) }

    it "should have the sponsor role" do
      expect(user.has_role?(:cakester)).to be true
      expect(user.has_role?(:sponsor)).to be false
      expect(user.has_role?(:fundraiser)).to be false
    end
    
    describe "#set_role" do
      it "should allow the user to set cakester he's related to" do
        expect(user.role).to be_nil
        user.set_role(cakester)
        expect(user.role).to eq cakester
        expect(user.registered).to be true
        expect(user.roles).to eq [:cakester]
      end
    end
  end

end
