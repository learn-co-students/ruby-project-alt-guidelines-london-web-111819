require 'pry'
class User < ActiveRecord::Base
  has_many :reviews
  has_many :dental_hygienists, through: :reviews

  def self.validate_username(username)
    User.find_by(username: username)
  end

  def self.validate_user(username, password)
    if User.find_by(username: username) != nil && User.find_by(password: password) != nil && User.find_by(username: username) == User.find_by(password: password)
      User.find_by(username: username)
    else
      nil
    end
  end    

end
