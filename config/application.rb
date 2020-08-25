require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Univer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0


    if Rails.env.development? # for rails-erd gem to generate a diagram
      def eager_load!
        Zeitwerk::Loader.eager_load_all
      end
    end

    # CJplftv дополнительную коныигурацию для RichText, чтобы можно было отображать прикрепленные видео
    config.to_prepare do
      ActionText::ContentHelper.allowed_attributes.add 'style'
      ActionText::ContentHelper.allowed_attributes.add 'controls'

      ActionText::ContentHelper.allowed_tags.add 'video'
      ActionText::ContentHelper.allowed_tags.add 'source'
      ActionText::ContentHelper.allowed_tags.add 'audio'
      # Settings in config/environments/* take precedence over those specified here.
      # Application configuration can go into files in config/initializers
      # -- all .rb files in that directory are automatically loaded after loading
      # the framework and any gems in your application.
    end
  end
end
