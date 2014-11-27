require 'spec_helper'
require 'validate_attributes'
require 'support/models'
require 'byebug'

RSpec.describe ValidateAttributes do
  it "adds validates_attribute method to ActiveModel::Validations" do
    expect(User.new).to respond_to(:validate_attributes)
  end

  context "without parameters" do
    let(:user) { User.new }
    before { user.validate_attributes }

    it "validates name" do
      expect(user.errors[:name]).to include("can't be blank")
      expect(user.errors[:name]).to include("is too short (minimum is 5 characters)")
    end

    it "validates email" do
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "validates address" do
      expect(user.errors[:address]).to include("can't be blank")
    end
  end

  context "with :only parameter, validates only the array" do
    let(:user) { User.new }
    before { user.validate_attributes(only: [:email]) }

    it "doesn't validate name" do
      expect(user.errors[:name]).to be_blank
    end

    it "doesn't validate address" do
      expect(user.errors[:address]).to be_blank
    end

    it "validate email" do
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  context "with except parameter, validates all but those" do
    let(:user) { User.new }
    before { @result = user.validate_attributes(except: [:email]) }

    it "returns false" do
      expect(@result).to be_falsey
    end

    it "doesn't validate name" do
      expect(user.errors[:name]).to_not be_blank
    end

    it "doesn't validate address" do
      expect(user.errors[:address]).to_not be_blank
    end

    it "validate email" do
      expect(user.errors[:email]).to be_blank
    end
  end

end
