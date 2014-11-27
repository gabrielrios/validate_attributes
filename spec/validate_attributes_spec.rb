require 'spec_helper'
require 'validate_attributes'
require 'support/models'

RSpec.describe ValidateAttributes do
  it "adds validates_attribute method to ActiveModel::Validations" do
    expect(User.new).to respond_to(:validate_attributes)
  end

  context "without parameters" do
    let(:user) { User.new }

    context "invalid" do
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

    it "valid" do
      user.name = "gabriel"
      user.email = "test@example.com"
      user.address = "Address Street"
      expect(user.validate_attributes).to be_truthy
    end
  end

  context "with :only parameter, validates only the array" do
    context "invalid" do
      let(:user) { User.new }
      before { @result = user.validate_attributes(:only => [:email]) }

      it "returns false" do
        expect(@result).to be_falsey
      end

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

    it "valid" do
      user = User.new :email => "email@example.org"
      expect(user.validate_attributes(:only => [:email])).to be_truthy
    end
  end

  context "with except parameter, validates all but those" do
    context "invalid" do
      let(:user) { User.new }
      before { @result = user.validate_attributes(:except => [:email]) }

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

    it "valid" do
      user = User.new :name => "Gabriel", :address => "Address Street"
      expect(user.validate_attributes(:except => [:email])).to be_truthy
    end
  end

  context "same validator for multiple attributes" do
    let(:post) { Post.new }
    before { post.validate_attributes(:only => :title) }

    it "validates only title" do
      expect(post.errors[:title]).to_not be_blank
      expect(post.errors[:content]).to be_blank
    end
  end


end
