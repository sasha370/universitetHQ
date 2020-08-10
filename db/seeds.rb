# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# Создаем тестового юзера
User.create!(email: 'test@test.ru', password: '123456')


30.times do
  # Создает 30 курсов  курс
  Course.create!([{
                      # в котором названия генерируются из папки Обучение
                      title: Faker::Educator.course_name,
                      # а описания из папки текстовок
                      description: Faker::TvShows::GameOfThrones.quote,
                      #  навешиваем все курсы к тестовому юзеру
                      user_id: User.first.id
                  }])
end