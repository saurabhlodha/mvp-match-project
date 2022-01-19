require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:valid_attributes) {
    FactoryBot.attributes_for(:user)
  }

  let(:token) { 'ABCD-MNOP-PQRS-XYZ' }
  let(:valid_headers) {
    { Authorization: token }
  }
  let(:secret_key) { Rails.application.secrets.secret_key_base }

  before do
    allow(JWT).to receive(:decode).with(token, secret_key).and_return([{ user_id: logged_in_user.id }])
  end
  let(:logged_in_user) { FactoryBot.create(:seller) }

  describe "POST /create" do
    it "creates a new User" do
      expect {
        post api_v1_users_url,
              params: { user: valid_attributes }, as: :json
      }.to change(User, :count).by(1)
    end

    it "renders a JSON response with the new product" do
      post api_v1_users_url,
            params: { user: valid_attributes }, as: :json
      expect(response).to have_http_status(:created)
      expect(response.content_type).to match(a_string_including("application/json"))
    end
  end

  describe "post /reset" do
    let(:valid_attributes) { { amount: 100 } }

    context 'when user is a buyer' do
      let(:logged_in_user) { FactoryBot.create(:buyer, deposit: 25) }

      it "deposits the amount" do
        post deposit_api_v1_users_url,
              params: valid_attributes, headers: valid_headers, as: :json
        logged_in_user.reload
        expect(logged_in_user.deposit).to be_eql 125
      end

      it "renders a JSON response with the user" do
        post deposit_api_v1_users_url,
              params: valid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context 'when user is a seller' do
      let(:logged_in_user) { FactoryBot.create(:seller, deposit: 0) }

      it "renders a JSON response with unauthorized error" do
        post deposit_api_v1_users_url,
              params: valid_attributes, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unauthorized)
        logged_in_user.reload
        expect(logged_in_user.deposit).to be_zero
      end
    end
  end

  describe "post /reset" do
    context 'when user is a buyer' do
      let(:logged_in_user) { FactoryBot.create(:buyer, deposit: 25) }

      it "resets the deposit" do
        post reset_api_v1_users_url, headers: valid_headers, as: :json

        logged_in_user.reload
        expect(logged_in_user.deposit).to be_zero
      end

      it "renders a JSON response with the user" do
        post reset_api_v1_users_url, headers: valid_headers, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context 'when user is a seller' do
      let(:logged_in_user) { FactoryBot.create(:seller, deposit: 10) }

      it "renders a JSON response with unauthorized error" do
        post reset_api_v1_users_url, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unauthorized)
        logged_in_user.reload
        expect(logged_in_user.deposit).to_not be_zero
      end
    end
  end
end
