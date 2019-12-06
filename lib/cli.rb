class Cli 

  def greet
    puts 'Welcome to Rate My Hygienist, the best resource for Dental Hygienist information!'
    login
  end

  
  def login
    prompt = TTY::Prompt.new
    username = prompt.ask("Please enter your username:", required: true)
    system "clear"
    if User.validate_username(username) == nil
      system "clear"
      puts "User does not exist!"

      choices = [
        {name: 'Create account', value: 1},
        {name: 'Try logging in again', value: 2},
      ]  
      user_input = prompt.select("Select an action:", choices)

      case user_input
      when 1
        system "clear"
        create_new_user
      when 2
        system "clear"
        login
      end
    else
      system "clear"
      password = prompt.mask("Please enter your password:", required: true)
      @current_user = User.validate_user(username, password)
      system "clear"
      if @current_user == nil
        puts "Password incorrect, try logging in again"
        login
      else
        #binding.pry
      option_screen 
      
      end
    end
  end


  def create_new_user
    prompt = TTY::Prompt.new
    user_input = prompt.ask("What would you like your username to be?")
    if User.all.map{|user| user.username}.include?(user_input)
      puts "This username has already been taken."

      choices = [
        {name: 'Choose another username', value: 1},
        {name: 'Return to login screen', value: 2},
      ]  
      user_input = prompt.select("Select an action:", choices)

      case user_input
      when 1
        system "clear"
        create_new_user
      when 2
        system "clear"
        login
      end
    else
      user_input2 = prompt.ask("What would you like your password to be?")
    User.create(username: user_input, password: user_input2)
    puts "Account created! Please now login with these details."
    login
    end
  end
  

  def option_screen 
    prompt = TTY::Prompt.new
    @current_user.reload
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
      system "clear"
      write_a_review
    when 2
      system "clear"
      view_my_reviews
    when 3
      system "clear"
      read_other_reviews_location
    when 4
      system "clear"
      reviews_by_hygienist
    when 5
      system "clear"
      log_out
    end
  end


  def write_a_review
    prompt = TTY::Prompt.new
    choices = DentalHygienist.hygienist_names
   system "clear"
    user_input = prompt.select("Which hygienist?") do |menu|
    choices.each do |name| 
      menu.choice name
      end
    end
    
    selected_hygienist =  DentalHygienist.find_by(name: user_input)
    system "clear"

       hash = prompt.collect do
       key(:star_review).ask("Star rating (1-5)?:", convert: :int) do |q|
        q.in '1-5'
        q.messages[:range?] = '%{value} out of expected range (1-5)'
       end
       key(:comment_review).ask("Write a comment review:")
      end
     hash

    Review.create(dental_hygienist_id: selected_hygienist.id, user_id: @current_user.id, star_review: hash[:star_review], comment_review: hash[:comment_review])
    system "clear"
    review_made
    
  end


  def review_made 
    prompt = TTY::Prompt.new
    puts "Your review was made!"
    choices = [
        {name: 'View my reviews', value: 1},
        {name: 'Return to main menu', value: 2}
      ]
      user_input = prompt.select("Select an action?", choices)

    case user_input
    when 1
      system "clear"
      view_my_reviews
    when 2
      system "clear"
      option_screen
    end
  end


  def view_my_reviews 
    @current_user.reload
    prompt = TTY::Prompt.new
    
    if @current_user.reviews.length <=0
      system "clear"
      puts "You have not written any reviews yet"
      
      choices = [
          {name: 'Write a review', value: 1},
          {name: 'Return to main menu', value: 2},
        ]
      user_input = prompt.select("Select an action?", choices)

      case user_input
      when 1
        system "clear"
        write_a_review
      when 2
        system "clear"
        option_screen
      end

    else
       
      my_reviews = @current_user.reviews.map {|review| "You gave #{review.dental_hygienist.name} a review of #{review.star_review} stars, '#{review.comment_review}'"}
      system "clear"
      puts "Here are your reviews:"
      puts my_reviews

      choices = [
          {name: 'Update a review', value: 1},
          {name: 'Delete a review', value: 2},
          {name: 'Return to main menu', value: 3}
        ]
      user_input = prompt.select("Select an action?", choices)

      case user_input
      when 1
        system "clear"
        update_my_review
      when 2
        system "clear"
        delete_my_review
      when 3
        system "clear"
        option_screen
      end
    end
  end


  def update_my_review 
  
    prompt = TTY::Prompt.new
    
     user_input = prompt.select("Select the review you'd like to update") do |menu|
     @current_user.reviews.each do |review , value| 
       menu.choice review.print_review_details, review.id
       end
     end
     
     selected_review = Review.find(user_input)
     system "clear"
     hash = prompt.collect do
      key(:star_review).ask("Change star rating to (1-5)?:", convert: :int) do |q|
        q.in '1-5'
        q.messages[:range?] = '%{value} out of expected range (1-5)'
      end
      key(:comment_review).ask("Change comment review to:")
     end
    hash

    choices = [
      {name: 'Yes, I want to update it', value: 1},
      {name: 'No, lets keep the original', value: 2}
    ]
    user_input = prompt.select("Are you sure you want to update this review?", choices)

    case user_input
    when 1
      selected_review.update(star_review: hash[:star_review], comment_review: hash[:comment_review])
    when 2
      system "clear"
      view_my_reviews
    end
     system "clear"
     updated_review
  end


  def updated_review
    prompt = TTY::Prompt.new
    puts "Your review has been updated!"
    
    choices = [
      {name: 'Return to main menu', value: 1},
      {name: 'View my reviews', value: 2}
    ]
    user_input = prompt.select("Select an action?", choices)

    case user_input
    when 1
      system "clear"
      option_screen
    when 2
      system "clear"
      view_my_reviews
    end
  end


  def delete_my_review 

    prompt = TTY::Prompt.new
    
     user_input = prompt.select("Select the review you'd like to delete") do |menu|
     @current_user.reviews.each do |review , value| 
       menu.choice review.print_review_details, review.id
       end
     end
     
     selected_review = Review.find(user_input) 
     system "clear"
     choices = [
      {name: 'Yes, I want to delete it', value: 1},
      {name: 'No, lets keep it', value: 2}
    ]
    user_input = prompt.select("Are you sure you want to delete this review?", choices)
    system "clear"
    case user_input
    when 1
      selected_review.delete
    when 2
      system "clear"
      view_my_reviews
    end
    system "clear"
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
      system "clear"
      option_screen
    when 2
      system "clear"
      view_my_reviews
    end
  end


  def read_other_reviews_location 
   
    prompt = TTY::Prompt.new
    
    user_input1 = prompt.select("Select location") do |menu|
      DentalHygienist.hygienist_locations.each do |location| 
        menu.choice location
        end
        system "clear"
      end
     
    Review.find_reviews_by_location(user_input1)
  
    choices = [
      {name: 'Return to main menu', value: 1},
      {name: 'View my reviews', value: 2}
    ]
    user_input2 = prompt.select("Select an action?", choices)
    
    case user_input2
    when 1
      system "clear"
      option_screen
    when 2
      system "clear"
      view_my_reviews
    end
  end


  def reviews_by_hygienist 
    prompt = TTY::Prompt.new

    user_input1 = prompt.select("Select name") do |menu|
      DentalHygienist.hygienist_names.each do |name| 
        menu.choice name
        end
        system "clear"
      end
    
    
    Review.find_reviews_by_name(user_input1)
    
    
    choices = [
      {name: 'Return to main menu', value: 1},
      {name: 'View my reviews', value: 2}
    ]
    user_input2 = prompt.select("Select an action?", choices)

    case user_input2
    when 1
      system "clear"
      option_screen
    when 2
      system "clear"
      view_my_reviews
    end
  end


  def log_out 
    puts "Logged out. See you soon!"
    login
  end

end