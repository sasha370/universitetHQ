class AddSlugToCourses < ActiveRecord::Migration[6.0]
  # Миграция добавляет дополнительную колонку к Курсам, чтобы ссылки в URL отображались дружественно
  def change
    add_column :courses, :slug, :string
    add_index :courses, :slug, unique: true
  end
end
