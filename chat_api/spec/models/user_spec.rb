require 'rails_helper'

RSpec.describe User, type: :model do

  it "is valid with a name and a password" do
    user = User.new(name: "User", password: "pass")
    expect(user).to be_valid
  end

  it "is invalid with a blank password" do
    user = User.new(name: "User", password: "")
    expect(user).to be_invalid
  end

  it "is invalid with a blank name" do
    user = User.new(name: "    ", password: "pass")
    expect(user).to be_invalid
  end
  
  it "is invalid with a too short name" do
    user = User.new(name: "a" * 3, password: "pass")
    expect(user).to be_invalid
  end
  
  it "is invalid with a too long name" do
    user = User.new(name: "a" * 51, password: "pass")
    expect(user).to be_invalid
  end
end
