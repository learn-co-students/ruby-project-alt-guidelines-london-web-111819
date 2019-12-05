class DentalHygienist < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    def self.hygienist_names #will return all hygienist names
        self.all.map{|hyg| hyg.name}
    end

    def self.hygienist_locations #will return all hyg locations
      self.all.map{|hyg| hyg.location}.uniq
    end


    def self.find_hygienists_by_location(user_input)
      self.where(location: user_input)
    end

    def self.find_hygienists_by_name(user_input)
      self.where(name: user_input)
    end

    #def most_reviews
     # DentalHygienist.all.max_by{|dh| dh.reviews.length}
    #end

    #def average_star_rating(dental_hygienist)
     # array = DentalHygienist.fourth.reviews.map{|review| review.star_review}
      #average = array.inject{|sum,n| sum+n} / array.length
    #end

    #CLEAR THE ABOVE METHODS BEFORE THE TEST.

end