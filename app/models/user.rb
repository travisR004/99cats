# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  attr_reader :password


  #before_validation :ensure_session_token
  validates :password, :length => {minimum: 3, allow_nil: true}
  validates :username, uniqueness: true, presence: true
  validates :password_digest, presence: true

  has_many :cats
  has_many :sessions

  def password=(pt)
    @password = pt
    self.password_digest = BCrypt::Password.create(pt)
  end

  def is_password?(pt)
    BCrypt::Password.new(self.password_digest).is_password?(pt)
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(params)
    user = User.find_by(:username => params[:username])
    user.try(:is_password?, params[:password]) ? user : nil
  end

  def reset_session_token!
     @session = Session.new(user_id: self.id, session_token: self.class.generate_session_token)
      @session.save!
      @session.session_token
    end

  private
    def ensure_session_token
      self.session_token ||= self.class.generate_session_token
    end
end
