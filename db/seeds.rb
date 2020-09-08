# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# Создаем тестового юзера
# user = User.new(
#     email: 'admin@admin.ru',
#     password: '123456',
#     password_confirmation: '123456',
# )
# user.skip_confirmation!
# user.save!

# отключавем т.к. он требует наличия current_user
PublicActivity.enabled = false
10.times do
  Course.create!([{
                      # в котором названия генерируются из папки Обучение
                      title: Faker::Educator.course_name,
                      # а описания из папки текстовок
                      description: Faker::TvShows::GameOfThrones.quote,
                      #  навешиваем все курсы к тестовому юзеру
                      user_id: User.first.id,
                      marketing_description: Faker::Quote.famous_last_words,
                      language: Faker::ProgrammingLanguage.name,
                      level: "Beginner",
                      price: Faker::Number.between(from: 1000, to: 20000)
                  }])
  # ключаем обратно
end
  PublicActivity.enabled = true
