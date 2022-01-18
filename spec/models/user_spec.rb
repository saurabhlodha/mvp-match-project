require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.build(:user) }

  describe "associations" do
    it do
      is_expected.to have_many(:products)
        .with_foreign_key(:seller_id)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:role) }

    context "#deposit_multiple_of_five" do
      let(:buyer) { FactoryBot.build(:buyer, deposit: deposit) }

      context "when deposit is not a multiple of 5" do
        let(:deposit) { 3 }

        it "returns error" do
          expect(buyer).to_not be_valid
          expect(buyer.errors.full_messages).to include 'Deposit must be multiple of 5'
        end
      end

      context "when deposit is a multiple of 5" do
        let(:deposit) { 15 }

        it { expect(buyer).to be_valid }
      end
    end
  end
end
