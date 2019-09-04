class User < ApplicationRecord

  validates :user_name, presence: true
  validates :password_digest, presence: true 
  validates :session_token, presence: true, uniqueness: true 
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token
  attr_reader :password 

  def reset_session_token! 
    self.session_token = self.class.generate_session_token
    # debugger
    self.save! 
    self.session_token
  end 

  def self.generate_session_token 
    SecureRandom::urlsafe_base64
  end 

  def password=(password) 
    # debugger
    @password = password
    self.password_digest = BCrypt::Password.create(password)
    # debugger
    # self.save! 
    # @password = self.password_digest
  end

  def is_password?(password) 
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = self.find_by(user_name: user_name)
    if user
      if user.is_password?(password) 
        return  user
      end
    else
      # flash.now[:errors] = ["improper credentials"]#user.errors.full_messages
      # render :new
      nil
    end
  end

  def ensure_session_token
    # debugger
    self.session_token ||= self.class.generate_session_token
  end 

end 