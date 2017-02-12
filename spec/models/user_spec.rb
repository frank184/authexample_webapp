require 'rails_helper'

RSpec.describe User, type: :model do

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:username).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
    end
  end

  describe "associations" do
  end

  describe "validation" do
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to allow_value('example@domain.com').for(:email) }
  end

  describe "attributes" do
    subject { build(:user, email: 'user@mail.com', username: 'user') }

    it { is_expected.to have_attributes(email: 'user@mail.com') }
  end
end
