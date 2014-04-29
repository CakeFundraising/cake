require 'spec_helper'

shared_examples 'a FR object' do
  it "can be created by a fundraiser" do
    @ability.should be_able_to(:create, klass)
  end

  it "cannot be created by a sponsor" do
    sponsor = FactoryGirl.create(:sponsor)
    ability = Ability.new(sponsor.manager)

    ability.should_not be_able_to(:create, klass)
  end

  it "cannot be created by a guest user" do
    ability = Ability.new(nil)
    ability.should_not be_able_to(:create, klass)
  end
end

shared_examples 'a Sponsor object' do
  it "can be created by a sponsor" do
    @ability.should be_able_to(:create, klass)
  end

  it "cannot be created by a fundraiser" do
    fundraiser = FactoryGirl.create(:fundraiser)
    ability = Ability.new(fundraiser.manager)

    ability.should_not be_able_to(:create, klass)
  end

  it "cannot be created by a guest user" do
    ability = Ability.new(nil)
    ability.should_not be_able_to(:create, klass)
  end
end

shared_examples 'an owned object' do
  context 'actions by the owner' do
    it "can edit his own object" do
      @ability.should be_able_to(:edit, owned_object)
    end

    it "can update his own object" do
      @ability.should be_able_to(:update, owned_object)
    end

    it "can destroy his own object" do
      @ability.should be_able_to(:destroy, owned_object)
    end
  end

  context 'actions by foreign user' do
    it "cannot edit someone else's object" do
      @ability.should_not be_able_to(:edit, foreign_object)
    end

    it "cannot update someone else's object" do
      @ability.should_not be_able_to(:update, foreign_object)
    end

    it "cannot destroy someone else's object" do
      @ability.should_not be_able_to(:destroy, foreign_object)
    end
  end
end

describe Ability do
  describe 'Sponsor' do
    before(:each) do
      @sponsor = FactoryGirl.create(:sponsor)
      @user = @sponsor.manager
      @ability = Ability.new(@user)
    end

    context 'Pledges' do
      it "can read pledges" do
        @pledges = create_list(:pledge, 5)
        @pledges.each do |p|
          @ability.should be_able_to(:read, p)
        end
      end

      it_behaves_like "a Sponsor object" do
        let(:klass) { Pledge }
      end

      it_behaves_like "an owned object" do
        let(:owned_object) { FactoryGirl.create(:pledge, sponsor: @sponsor) }
        let(:foreign_object) { FactoryGirl.create(:pledge) }
      end
    end
  end

  describe "Fundraiser" do
    before(:each) do
      @fundraiser = FactoryGirl.create(:fundraiser)
      @user = @fundraiser.manager
      @ability = Ability.new(@user)
    end

    context 'Campaigns' do
      it_behaves_like "a FR object" do
        let(:klass) { Campaign }
      end

      it_behaves_like "an owned object" do
        let(:owned_object) { FactoryGirl.create(:campaign, fundraiser: @fundraiser) }
        let(:foreign_object) { FactoryGirl.create(:campaign) }
      end
    end

    context 'Pledge Requests' do
      it_behaves_like "a FR object" do
        let(:klass) { PledgeRequest }
      end

      it_behaves_like "an owned object" do
        let(:owned_object) { FactoryGirl.create(:pledge_request, fundraiser: @fundraiser) }
        let(:foreign_object) { FactoryGirl.create(:pledge_request) }
      end
    end
  end
end