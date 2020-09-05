source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :production do
  gem 'pg'
end

# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "bootstrap" # основное оформление
gem 'jquery-rails' # поддержка событий JS
gem 'haml-rails', "~> 2.0" # формат для создания страниц
gem 'font-awesome-sass' # набор значков для оформления
gem 'simple_form' # создает формы поддерживаемые bootstrap
gem 'faker' # создает seeds в БД по шаблонам быстро и просто
gem 'devise' # для аутентификации пользователй
gem 'friendly_id' # дружественное тображение ссылок
gem 'ransack', github: 'activerecord-hackery/ransack' # поиск и сортировка по любым полям
gem 'public_activity' # отслеживание всех действий пользователей на сайте
gem 'rolify'  # для создания ролей у User-ов
gem 'pundit' # для создания прав на различные роли
gem 'exception_notification', group: :production # отправляет все ошибки Heroku на почту
gem 'pagy'  # пагинатор
gem 'chartkick' # отображение графиков
gem 'groupdate' # групировка данных из БД по времени ( нужен для Графиков)
gem 'rails-erd', group: :development # sudo apt-get install graphviz
gem 'ranked-model' # ранжирование внутри модели
# работает совместно с jquery -ui

gem 'aws-sdk-s3', require: false  # для хранения файлов на серверах Amazon
gem 'active_storage_validations'  # вылидация для загружаемых файлов ( тип, расширение и т.д.)
gem 'image_processing' # подгрузка картинок из S3
gem 'recaptcha'
gem 'wicked_pdf'  # haml2pdf generator для создания сертификатов об окончании курса
gem 'wkhtmltopdf-binary', group: :development  # вспомогательный гем для wicked_pdf
gem 'wkhtmltopdf-heroku', group: :production # вспомогательный гем для wicked, т.к. без него приложение занимает в 5 раз больше места на сервере, т..к хранит все pdf
gem 'omniauth-google-oauth2' # аутентификация через Гугл
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'   # аутентификация через GitHub
gem 'omniauth-facebook'   # аутентификация через Facebook
gem 'wicked'  # multistep-form
gem 'cocoon'
gem 'stripe'

#yarn add selectize   -  гем для быстрого выбора тегов
