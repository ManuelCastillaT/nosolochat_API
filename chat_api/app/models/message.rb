class Message
    include Mongoid::Document
  
    field :text, type: String
    field :owner_name, type: String
  
    belongs_to :chatroom
    
    # Validation
    validates :text, presence: true, length: { maximum: 280 }
    validates :owner_name, presence: true, length: { minimum: 4, maximum: 50 }
  end