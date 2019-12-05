20.times do 
    User.create(
        username: Faker::Internet.username
    )
end

20.times do 
    DentalHygienist.create(
        name: Faker::Name.first_name,
        location: Faker::Nation.capital_city
    )
end

30.times do
    Review.create(
        dental_hygienist_id: Faker::Number.within(range: 1..20),
        user_id: Faker::Number.within(range: 1..20),
        comment_review: Faker::Hipster.sentence(word_count: 3),
        star_review: Faker::Number.within(range: 1..5)
    )
 
end

