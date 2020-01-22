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

    def self.find_hygienist_by_name(user_input)
      DentalHygienist.find_by(name: user_input)
    end

    def self.hygienists_with(number)
      self.all.select{|dh| dh.star_reviews.include?(number)}
    end

    def star_reviews
      self.reviews.map {|review| review.star_review}
    end

end