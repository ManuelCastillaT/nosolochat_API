require 'rails_helper'

RSpec.describe Chatroom, type: :model do
  
  it "is valid with messages" do
    chatroom = Chatroom.new(name: "a" * 5)
    message = Message.new(text: "a" * 150, owner_name: "User")
    message.chatroom = chatroom
    chatroom.messages << message
    expect(chatroom).to be_valid
  end

  it "is valid without messages" do
    chatroom = Chatroom.new(name: "a" * 5)
    expect(chatroom).to be_valid
  end

  it "is invalid without a blank name" do
    chatroom = Chatroom.new(name: "     ")
    expect(chatroom).to be_invalid
  end
  
  it "is invalid with a too long name" do
    chatroom = Chatroom.new(name: "a" * 51)
    expect(chatroom).to be_invalid
  end
  
  it "is invalid with a too short name" do
    chatroom = Chatroom.new(name: "a" * 3)
    expect(chatroom).to be_invalid
  end
end
