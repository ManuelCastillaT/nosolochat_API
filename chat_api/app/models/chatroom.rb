class Chatroom
  include Mongoid::Document

  field :name, type: String
  
  has_many :messages
  
  # Validation
  validates :name, presence: true, uniqueness: true, length: { maximum: 50, minimum: 4 }

  def to_param
    :name
  end

end
