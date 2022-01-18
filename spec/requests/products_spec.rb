require 'rails_helper'

RSpec.describe "/products", type: :request do
  let(:valid_attributes) {
    FactoryBot.attributes_for(:product)
  }

  let(:token) { 'ABCD-MNOP-PQRS-XYZ' }
  let(:valid_headers) {
    { Authorization: token }
  }
  let(:secret_key) { Rails.application.secrets.secret_key_base }

  before do
    allow(JWT).to receive(:decode).with(token, secret_key).and_return([{ user_id: logged_in_user.id }])
  end

  describe "GET /index" do
    let!(:product) { FactoryBot.create(:product) }

    context 'when user is a buyer' do
      let(:logged_in_user) { FactoryBot.create(:buyer) }

      it "renders a successful response" do
        get api_v1_products_url, headers: valid_headers, as: :json

        expect(response).to be_successful
        expect(assigns(:products)).to include product
      end
    end

    context 'when user is a seller' do
      let(:logged_in_user) { FactoryBot.create(:seller) }

      it "renders a successful response" do
        get api_v1_products_url, headers: valid_headers, as: :json

        expect(response).to be_successful
        expect(assigns(:products)).to include product
      end
    end
  end

  describe "GET /show" do
    let(:product) { FactoryBot.create(:product) }

    context 'when user is a buyer' do
      let(:logged_in_user) { FactoryBot.create(:buyer) }

      it "renders a successful response" do
        get api_v1_product_url(product), headers: valid_headers, as: :json

        expect(response).to be_successful
        expect(assigns(:product)).to be_eql product
      end
    end

    context 'when user is a seller' do
      let(:logged_in_user) { FactoryBot.create(:seller) }

      it "renders a successful response" do
        get api_v1_product_url(product), headers: valid_headers, as: :json

        expect(response).to be_successful
        expect(assigns(:product)).to be_eql product
      end
    end
  end

  describe "POST /create" do
    context 'when user is a seller' do
      let(:logged_in_user) { FactoryBot.create(:seller) }

      it "creates a new Product" do
        expect {
          post api_v1_products_url,
               params: { product: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        post api_v1_products_url,
             params: { product: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context 'when user is a buyer' do
      let(:logged_in_user) { FactoryBot.create(:buyer) }

      it "does not create a new Product" do
        expect {
          post api_v1_products_url,
               params: { product: valid_attributes }, as: :json
        }.to change(Product, :count).by(0)
      end

      it "renders a JSON response with unauthorized error" do
        post api_v1_products_url,
             params: { product: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /update" do
    let(:product) { FactoryBot.create(:product) }
    let(:new_attributes) {
      { amount_available: 100, cost: 120 }
    }

    context 'when user is a seller' do
      let(:logged_in_user) { product.seller }

      it "updates the requested product" do
        patch api_v1_product_url(product),
              params: { product: new_attributes }, headers: valid_headers, as: :json
        product.reload
        expect(product.amount_available).to be_eql 100
        expect(product.cost).to be_eql 120
      end

      it "renders a JSON response with the product" do
        patch api_v1_product_url(product),
              params: { product: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context 'when user is a buyer' do
      let(:logged_in_user) { FactoryBot.create(:buyer) }

      it "renders a JSON response with unauthorized error" do
        patch api_v1_product_url(product),
              params: { product: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:product) { FactoryBot.create(:product) }

    context 'when user is a seller' do
      let(:logged_in_user) { product.seller }

      it "destroys the requested product" do
        expect {
          delete api_v1_product_url(product), headers: valid_headers, as: :json
        }.to change(Product, :count).by(-1)
      end
    end

    context 'when user is a buyer' do
      let(:logged_in_user) { FactoryBot.create(:buyer) }

      it "destroys the requested product" do
        expect {
          delete api_v1_product_url(product), headers: valid_headers, as: :json
        }.to change(Product, :count).by(0)
      end

      it "renders a JSON response with unauthorized error" do
        delete api_v1_product_url(product), headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /buy" do
    let(:product) { FactoryBot.create(:product, cost: 10, amount_available: 10) }
    let(:buy_attributes) {
      { amount: 2 }
    }

    context 'when user is a buyer' do
      let(:logged_in_user) { FactoryBot.create(:buyer, deposit: 100) }

      it "buys the requested product" do
        post api_v1_product_buy_url(product),
              params: buy_attributes, headers: valid_headers, as: :json

        logged_in_user.reload
        product.reload
        expect(logged_in_user.deposit).to be_eql 80
        expect(product.amount_available).to be_eql 8
      end

      it "renders a JSON response with the product" do
        post api_v1_product_buy_url(product),
              params: buy_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context 'when user is a seller' do
      let(:logged_in_user) { product.seller }

      it "renders a JSON response with unauthorized error" do
        post api_v1_product_buy_url(product),
              params: buy_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
