require 'pry'
class User < ActiveRecord::Base
  has_many :reviews
  has_many :dental_hygienists, through: :reviews

 def get_ar_user #this retrieves the correct object hash for @current_user 
  User.all.find(self.id) #(as differs with User.all, so CRUD actions are logged on
 end                     #view_my_reviews page when we return to it

  def self.validate_user(username)
    @current_user = User.find_by(username: username) #ask charley if this is doing the
  end       #same thing as on CLI @current_user= User.validate_user(username)

end