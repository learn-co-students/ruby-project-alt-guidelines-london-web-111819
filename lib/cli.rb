class Cli 

  
  #greet method greets and calls login method
  def greet
    puts 'Welcome to Rate My Hygienist, the best resource for Dental Hygienist information!'
    login
  end

  #login method assigns prompt, takes input and calls option screen
  def login
    prompt = TTY::Prompt.new
    username = prompt.ask("Please enter your username:", required: true)
    @current_user = User.validate_user(username)
    binding.pry
    option_screen
  end
  

  def option_screen #this allows user to select an option between 1-5 & leads them to associated page
    prompt = TTY::Prompt.new
    choices = [
        {name: 'Write a review', value: 1},
        {name: 'View my reviews', value: 2},
        {name: 'Read other reviews by location', value: 3},
        {name: 'Hygienist search', value: 4},
        {name: 'Log out', value: 5}
      ]
      
    user_input = prompt.select("Select an action?", choices)

    case user_input
    when 1
      write_a_review
    when 2
      view_my_reviews
    when 3
      read_other_reviews_location
    when 4
      reviews_by_hygienist
    when 5
      log_out
    end
  end

  def write_a_review #working!
    prompt = TTY::Prompt.new
    choices = DentalHygienist.hygienist_names
   
    user_input = prompt.select("Which hygienist?") do |menu|
    choices.each do |name| 
      menu.choice name
      end
    end
    selected_hygienist =  DentalHygienist.find_by(name: user_input)

       hash = prompt.collect do
       key(:star_review).ask("Star rating (1-5)?:", convert: :int) do |q|
        q.in '1-5'
        q.messages[:range?] = '%{value} out of expected range (1-5)'
       end
       key(:comment_review).ask("Write a comment review:")
      end
     hash


    Review.create(dental_hygienist_id: selected_hygienist.id, user_id: @current_user.get_ar_user.id, star_review: hash[:star_review], comment_review: hash[:comment_review])
    
       review_made
  
  end

  def review_made #tells user input was successfully made and stored, gives option to return to options list or view reviews made.
    prompt = TTY::Prompt.new
    puts "Your review was made!"
    choices = [
        {name: 'View my reviews', value: 1},
        {name: 'Return to main menu', value: 2}
      ]
      
    user_input = prompt.select("Select an action?", choices)

    case user_input
    when 1
      view_my_reviews
    when 2
      option_screen
    end
  end

  def view_my_reviews #instance method required
    prompt = TTY::Prompt.new
    puts "Here are your reviews:"

    my_reviews = @current_user.get_ar_user.reviews.map {|review| "You gave #{review.dental_hygienist.name} a review of #{review.star_review} stars, '#{review.comment_review}'"}
    
    puts my_reviews

    choices = [
        {name: 'Update a review', value: 1},
        {name: 'Delete a review', value: 2},
        {name: 'Return to main menu', value: 3}
      ]
      
    user_input = prompt.select("Select an action?", choices)

    case user_input
    when 1
      update_my_review
    when 2
      delete_my_review
    when 3
      option_screen
    end
  end


  def update_my_review 
  
    prompt = TTY::Prompt.new
    
     user_input = prompt.select("Select the review you'd like to update") do |menu|
     @current_user.get_ar_user.reviews.each do |review , value| 
       menu.choice review.print_review_details, review.id
       end
     end
     

     selected_review = Review.find(user_input)
     
     hash = prompt.collect do
      key(:star_review).ask("Change star rating to (1-5)?:", convert: :int) do |q|
        q.in '1-5'
        q.messages[:range?] = '%{value} out of expected range (1-5)'
      end
      key(:comment_review).ask("Change comment review to:")
     end
    hash

     selected_review.update(star_review: hash[:star_review], comment_review: hash[:comment_review])

     selected_review.save
     
    
    #instance method required
    #allows a user to select a review for updating (not done yet).
    #allows a user to change review content
     updated_review
  end

  def updated_review#tells user their review has been updated and gives options of where to go next
    prompt = TTY::Prompt.new
    puts "Your review has been updated!"
    
    choices = [
      {name: 'Return to main menu', value: 1},
      {name: 'View my reviews', value: 2}
    ]
    
    user_input = prompt.select("Select an action?", choices)

    case user_input
    when 1
      option_screen
    when 2
      view_my_reviews
    end
  end

  def delete_my_review 

    prompt = TTY::Prompt.new
    
     user_input = prompt.select("Select the review you'd like to delete") do |menu|
     @current_user.get_ar_user.reviews.each do |review , value| 
       menu.choice review.print_review_details, review.id
       end
     end
     

     selected_review = Review.find(user_input)

     choices = [
      {name: 'Yes, I want to delete it', value: 1},
      {name: 'No, lets keep it', value: 2}
    ]
    
    user_input = prompt.select("Are you sure you want to delete this review?", choices)

    case user_input
    when 1
      selected_review.delete
    when 2
      view_my_reviews
    end
    
    #instance method required
    #allows user to select a review for deleting.
    #allows user to delete a review
    deleted_review
  end

  def deleted_review 
    prompt = TTY::Prompt.new
    puts "Your review was deleted!"
    
    choices = [
      {name: 'Return to main menu', value: 1},
      {name: 'View my reviews', value: 2}
    ]
    
    user_input = prompt.select("Select an action?", choices)

    case user_input
    when 1
      option_screen
    when 2
      view_my_reviews
    end
  end

  def read_other_reviews_location #class method requires
    #user inputs location town
    #user gets returned a list of reviews for that town, ordered from highest star rating to lowest
    prompt = TTY::Prompt.new
    user_input1 = prompt.select("Select location") do |menu|
      DentalHygienist.hygienist_locations.each do |location| 
        menu.choice location
        end
      end

    Review.find_reviews_by_location(user_input1)
    
    choices = [
      {name: 'Return to main menu', value: 1},
      {name: 'View my reviews', value: 2}
    ]
    
    user_input2 = prompt.select("Select an action?", choices)

    case user_input2
    when 1
      option_screen
    when 2
      view_my_reviews
    end
  end

  def reviews_by_hygienist #class method required
    #allows user to imput name and get returned that hygienist instances star and comment reviews
    #if input name is true (in database), then return reviews, if not, return message "no such hygienist found"
    prompt = TTY::Prompt.new

    user_input1 = prompt.select("Select name") do |menu|
      DentalHygienist.hygienist_names.each do |name| 
        menu.choice name
        end
      end

    Review.find_reviews_by_name(user_input1)
    
    choices = [
      {name: 'Return to main menu', value: 1},
      {name: 'View my reviews', value: 2}
    ]
    
    user_input2 = prompt.select("Select an action?", choices)

    case user_input2

    when 1
      option_screen
    when 2
      view_my_reviews
    end
  end

  def log_out #tells users they've logged out and returns them to the login screen.
    puts "Logged out. See you soon!"
    login
  end

end