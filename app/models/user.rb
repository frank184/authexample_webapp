class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :token_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  validates_uniqueness_of :username
end
