class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  
  field :name, type: String
  field :password_digest, type: String
  
  # Validation
  validates :name, presence: true, uniqueness: true, length: { minimum: 4, maximum: 50 }

  has_secure_password
  validates :password_digest, presence: true
end
