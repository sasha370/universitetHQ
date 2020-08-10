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
gem 'friendly_id'
gem 'ransack'
gem 'public_activity'
gem 'rolify'
gem 'pundit'
gem 'exception_notification', group: :production
gem 'pagy'
gem 'chartkick'
gem 'groupdate'
gem 'rails-erd', group: :development # sudo apt-get install graphviz
gem 'ranked-model'
gem 'aws-sdk-s3', require: false
gem 'active_storage_validations'
gem 'image_processing'
gem 'recaptcha'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', group: :development
gem 'wkhtmltopdf-heroku', group: :production
gem 'wicked'
gem 'omniauth-google-oauth2'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-facebook'
gem 'cocoon'
gem 'stripe'

