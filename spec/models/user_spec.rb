require 'rails_helper'

describe User do
  it { should have_one(:fundraiser_email_setting) }
  it { should belong_to(:sponsor) }
  it { should belong_to(:fundraiser) }

  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  context 'Fundraiser user' do
    let(:user){ FactoryGirl.create(:fundraiser_user) }
    let(:fundraiser){ FactoryGirl.create(:fundraiser) }

    it "should have the fundraiser role" do
      expect(user.has_role?(:fundraiser)).to be true
      expect(user.has_role?(:sponsor)).to be false
    end
    
    describe "#set_fundraiser" do
      it "should allow the user to set fundraiser he's related to" do
        expect(user.fundraiser).to be_nil
        user.set_fundraiser(fundraiser)
        expect(user.fundraiser).to eq fundraiser
      end
    end
  end

  context 'Sponsor user' do
    let(:user){ FactoryGirl.create(:sponsor_user) }
    let(:sponsor){ FactoryGirl.create(:sponsor) }

    it "should have the sponsor role" do
      expect(user.has_role?(:sponsor)).to be true
      expect(user.has_role?(:fundraiser)).to be false
    end
    
    describe "#set_sponsor" do
      it "should allow the user to set sponsor he's related to" do
        expect(user.sponsor).to be_nil
        user.set_sponsor(sponsor)
        expect(user.sponsor).to eq sponsor
      end
    end
  end

end
