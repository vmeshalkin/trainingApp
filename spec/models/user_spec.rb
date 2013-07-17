# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before { @user = User.new(name: "John Doe", email: "jd@example.com",
                           password: 'qwerty', password_confirmation: 'qwerty') }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }


  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should respond_to(:authenticate) }

  it { should_not respond_to(:age) }

  it { should be_valid }

  describe "should be valid" do
    
    describe "when name is there" do
      before { @user.name = "Jane Doe" }
      it { should be_valid }
    end

    describe "when email is valid" do
      it "should be valid" do
        addrs = ["a@example.com", "ruby.on.rails@rubyonrails.org", 
          "me+my@example.com", "get_info@example.net", "no-money@all.com",
          "third@level.domain.name"]
        addrs.each do |valid_email|
          @user.email = valid_email
          @user.should be_valid
        end
      end
    end

  end

  describe "should not be valid" do

    describe "when name is not present" do
      before { @user.name = "" }
      it { should_not be_valid }
    end

    describe "when name is blank" do
      before { @user.name = "  " }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @user.name = "adg" * 30 }
      it { should_not be_valid }
    end

    describe "when email is not present" do
      before { @user.email = "" }
      it { should_not be_valid }
    end

    describe "when email is invalid" do
      before { @user.email = "jewnnwiovweoinvieownv" }
      it { should_not be_valid }
    end

    describe "when email is taken" do
      before { @user_with_same_email = @user.dup; @user_with_same_email.save }
      it { should_not be_valid }
    end

    describe "when password is blank" do
      before { @user.password = @user.password_confirmation = " " }
      it { should_not be_valid }
    end

    describe "when password is too short" do
      before { @user.password = @user.password_confirmation = "a"*5 }
      it { should_not be_valid }
    end

    describe "when password is not confirmed" do
      before { @user.password = "4124214" }
      it { should_not be_valid }
    end

    describe "when password_confirmation is not present" do
      before { @user.password_confirmation = nil }
      it { should_not be_valid }
    end

  end

  describe "return value of authenticate method" do
    
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email)}

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end

  end

end