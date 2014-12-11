require 'spec_helper'

describe BrowsersController, type: :controller do
  describe "PATCH #fingerprint" do
    let(:attributes) { FactoryGirl.attributes_for(:browser) }
    let(:request) { patch :fingerprint, fingerprint: attributes[:fingerprint], ec_token: attributes[:token] }

    it "should receive fingerprint and token params" do
      request
      expect( assigns(:fingerprint) ).to eq( attributes[:fingerprint] )
      expect( assigns(:evercookie_token) ).to eq( attributes[:token] )
    end

    context "New browser" do
      it "should create a new browser object" do
        expect{ request }.to change{ Browser.count }.by(1)
      end

      it "should return the new browser id" do
        request
        expect( response.body ).to eq( Browser.last.id.to_s )
      end
    end

    context "Existing browser" do
      before(:each) do
        @browser = Browser.create(attributes)
      end

      context 'Already stored' do
        it "should not create a new browser" do
          expect{ request }.not_to change{ Browser.count }
        end

        it "should return the current browser id" do
          request
          expect( response.body ).to eq( @browser.id.to_s )
        end
      end

      context 'Same fingerprint' do
        let(:new_token) { SecureRandom.uuid.to_s }
        let(:same_fingerprint_request) { patch :fingerprint, fingerprint: @browser.fingerprint, ec_token: new_token }

        it "should use the existing token in the session" do
          same_fingerprint_request
          expect( session[:evercookie][:cfbid] ).to eq( @browser.token )
        end

        it "should not replace the old token with the new one" do
          same_fingerprint_request
          expect( @browser.reload.token ).to eq( @browser.token )
          expect( @browser.reload.token ).not_to eq( new_token )
        end

        it "should not replace the fingerprint attribute" do
          same_fingerprint_request
          expect( @browser.reload.fingerprint ).to eq( @browser.fingerprint )
        end

        it "should return the id of the existing browser" do
          same_fingerprint_request
          expect( response.body ).to eq( @browser.id.to_s )
        end
      end

      context 'Same Token' do
        let(:new_fingerprint) { SecureRandom.random_number(10000000000).to_s }
        let(:same_token) { @browser.token }
        let(:same_token_request) { patch :fingerprint, fingerprint: new_fingerprint, ec_token: same_token }

        it "should use the same token in the session" do
          same_token_request
          expect( session[:evercookie][:cfbid] ).to eq( same_token )
        end

        it "should replace the old fingerprint with the new one" do
          same_token_request
          expect( @browser.reload.fingerprint ).to eq( new_fingerprint )
        end

        it "should not replace the token attribute" do
          same_token_request
          expect( @browser.reload.token ).to eq( same_token )
        end

        it "should return the id of the existing browser" do
          same_token_request
          expect( response.body ).to eq( @browser.id.to_s )
        end
      end

    end
  end
end
