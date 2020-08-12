class ApplicationMailer < ActionMailer::Base
  default from: 'support@universary.heroku.com'
  layout 'mailer'
end
