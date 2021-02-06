@avatars = ['app/assets/images/angular.png',
            'app/assets/images/angular2.png',
            'app/assets/images/github.jpg',
            'app/assets/images/heroku.png',
            'app/assets/images/js.jpg',
            'app/assets/images/node.png',
            'app/assets/images/rails1.png',
            'app/assets/images/rails2.jpg',
            'app/assets/images/rails3.png']

PublicActivity.enabled = false

@users = []
3.times do |i|
  @users << User.create!(email: "test#{i}@test.ru", password: '123456', created_at: Time.now, confirmed_at: Time.now)
end
@users << User.create!(email: "admin@admin.ru", password: '123456', created_at: Time.now, confirmed_at: Time.now)

@courses = []
20.times do
  course = Course.new(title: Faker::Educator.course_name,
                      description: Faker::TvShows::GameOfThrones.quote,
                      user_id: @users.sample.id,
                      marketing_description: Faker::Quote.famous_last_words,
                      language: ["English", "Russian", "France", "Spanish"].sample,
                      level: ["Beginner", "Intermediate", "Advance"].sample,
                      price: Faker::Number.between(from: 1000, to: 20000),
                      approved: true,
                      published: true
  )
  course.avatar.attach(io: File.open(@avatars.sample), filename: 'avatar')
  course.save!
  @courses << course

end

@courses.each do |course|
  rand(0..10).times do
    course.lessons.create(
      title: Faker::Lorem.sentence(word_count: 3),
      content: Faker::Lorem.sentence(word_count: 10)
    )
  end
end

40.times do
  course = @courses.sample
  user = @users.sample
  if course.user_id != user.id
    user.buy_course(course)
  end
end

PublicActivity.enabled = true
