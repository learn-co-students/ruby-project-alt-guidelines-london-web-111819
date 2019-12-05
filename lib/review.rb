class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :dental_hygienist

  

  def print_review_details
    # binding.pry
    puts "name: #{self.dental_hygienist.name}, star rating: #{self.star_review}, review: #{self.comment_review}"
  end

  def self.find_reviews_by_location(user_input) #takes a location
    array = DentalHygienist.find_hygienists_by_location(user_input).map {|hyg| hyg.id}
     
    new_array = array.map{|id| Review.find_by({dental_hygienist_id:id})}
    #produces an array of instances^
    # binding.pry
    new_array2 = new_array.map{|review| review.print_review_details}
    #using method above, puts array of strings of info user wants to see from instance^
    
    if new_array.length <= 0
      puts "There are no reviews for hygienists in this location yet."
    else
      puts new_array2
    end  
  end

  def self.find_reviews_by_name(user_input)
    array = DentalHygienist.find_hygienists_by_name(user_input).map {|hyg| hyg.id}
     
    new_array = array.map{|id| Review.find_by({dental_hygienist_id:id})}
    #this produces an array of instances^
    new_array2 = new_array.map{|review| review.print_review_details}
    #using the method above, prints out just the bits the user wants to see from instance
    
    if new_array.length <= 0
      puts "There are no reviews for hygienists in this location yet."
    else
      puts new_array2
    end  


  end


end