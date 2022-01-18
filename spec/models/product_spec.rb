require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { FactoryBot.build(:product, cost: 5) }

  describe "associations" do
    it do
      is_expected.to belong_to(:seller)
        .class_name('User')
        .with_foreign_key(:seller_id)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:amount_available) }
    it { is_expected.to validate_presence_of(:product_name) }

    context "#cost_multiple_of_five" do
      let(:product) { FactoryBot.build(:product, cost: cost) }

      context "when cost is not a multiple of 5" do
        let(:cost) { 3 }

        it "returns error" do
          expect(product).to_not be_valid
          expect(product.errors.full_messages).to include 'Cost must be multiple of 5'
        end
      end

      context "when cost is a multiple of 5" do
        let(:cost) { 15 }

        it { expect(product).to be_valid }
      end
    end
  end
end
