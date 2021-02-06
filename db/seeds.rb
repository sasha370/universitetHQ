PublicActivity.enabled = false
@users = []
10.times do |i|
  @users << User.create!(email: "test#{i}@test.ru", password: '123456', created_at: Time.now, confirmed_at: Time.now)
end

@courses = []
20.times do
  @courses << Course.create!([{
                      title: Faker::Educator.course_name,
                      description: Faker::TvShows::GameOfThrones.quote,
                      user_id: @users.sample,
                      marketing_description: Faker::Quote.famous_last_words,
                      language: Faker::ProgrammingLanguage.name,
                      level: "Beginner",
                      price: Faker::Number.between(from: 1000, to: 20000)
                  }])
end


30.times do
  Lesson.create(
    title: Faker::Lorem.words(number: 4),
    content: Faker::Lorem.words(number: 20),
    course_id: @courses.sample

  )
end

  PublicActivity.enabled = true
