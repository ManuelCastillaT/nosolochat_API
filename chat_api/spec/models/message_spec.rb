require 'rails_helper'

RSpec.describe Message, type: :model do

  it "is valid with correct text, owner_name and chatroom" do
    message = Message.new(text: "a" * 150, owner_name: "User")
    message.chatroom = Chatroom.new(name: "Chat1")
    expect(message).to be_valid
  end

  it "is invalid without a chatroom" do
    message = Message.new(text: "a" * 150, owner_name: "User")
    expect(message).to be_invalid
  end

  it "is invalid without an owner_name" do
    message = Message.new(text: "a" * 150)
    message.chatroom = Chatroom.new(name: "Chat1")
    expect(message).to be_invalid
  end

  it "is invalid with a blank text" do
    message = Message.new(text: "       ", owner_name: "User")
    message.chatroom = Chatroom.new(name: "Chat1")
    expect(message).to be_invalid
  end
  
  it "is invalid with a too long name" do
    message = Message.new(text: "a" * 281, owner_name: "User")
    message.chatroom = Chatroom.new(name: "Chat1")
    expect(message).to be_invalid
  end
end
