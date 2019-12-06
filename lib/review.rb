class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :dental_hygienist

  

  def print_review_details
    "name: #{self.dental_hygienist.name}, star rating: #{self.star_review}, review: #{self.comment_review}"
  end

  def self.find_reviews_by_location(user_input) 
    array = DentalHygienist.find_hygienists_by_location(user_input).map {|hyg| hyg.id}
     
    new_array = array.map{|id| Review.find_by({dental_hygienist_id:id})}
    
    if new_array.length >=2 || new_array[0] != nil
      new_array2 = new_array.map{|review| review.print_review_details}
      puts new_array2
    else

    puts "There are no reviews for hygienists in that location yet"
    
    end  
  end

  def self.find_reviews_by_name(user_input)
    hygienist = DentalHygienist.find_hygienist_by_name(user_input)
     
    array = Review.where(dental_hygienist_id: hygienist.id)
     
  
    new_array = array.map{|review| review.print_review_details}
    
    
    if new_array.length <= 0
      puts "There are no reviews for this hygienist yet."
    else
      puts new_array
    end  


  end


end